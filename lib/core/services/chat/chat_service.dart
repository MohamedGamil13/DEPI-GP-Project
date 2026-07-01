import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

/// Thrown when any [ChatService] operation fails.
class ChatServiceException implements Exception {
  const ChatServiceException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() =>
      'ChatServiceException: $message'
      '${cause != null ? ' (cause: $cause)' : ''}';
}

abstract interface class IChatService {
  // ── One-shot fetches ───────────────────────────────────────────────────────
  Future<List<ChatMessage>> getChatMessages(String conversationId);
  Future<List<ChatMessage>> getOlderMessages({
    required String conversationId,
    required DateTime before,
    int limit,
  });
  Future<List<ConversationModel>> getAllConversations(String userId);
  Future<ConversationModel?> getConversation(String conversationId);

  // ── Real-time streams ──────────────────────────────────────────────────────
  Stream<List<ChatMessage>> watchMessages(String conversationId);
  Stream<List<ConversationModel>> watchConversations(String userId);

  // ── Mutations ──────────────────────────────────────────────────────────────
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String receiverId,
  });

  Future<void> markMessagesAsRead({
    required String conversationId,
    required String currentUserId,
  });

  Future<void> updateConversationStatus({
    required String conversationId,
    required ConversationStatus status,
  });

  Future<ConversationModel> createConversation(ConversationModel conversation);

  Future<ConversationModel?> findConversation({
    required String providerId,
    required String customerId,
    required String serviceId,
  });

  Future<void> deleteConversation(String conversationId);
}

/// Firestore-backed implementation of [IChatService].
///
/// Collection layout:
///   conversations/{conversationId}                 — ConversationModel (no messages field)
///   conversations/{conversationId}/messages/{msgId} — ChatMessage
class ChatService implements IChatService {
  ChatService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ── Collection helpers ─────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messages(String conversationId) =>
      _conversations.doc(conversationId).collection('messages');

  // ── One-shot fetches ───────────────────────────────────────────────────────

  @override
  Future<List<ChatMessage>> getChatMessages(String conversationId) async {
    try {
      final snapshot = await _messages(
        conversationId,
      ).orderBy('sentAt', descending: false).get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), id: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw ChatServiceException(
        'Failed to fetch messages for conversation $conversationId',
        cause: e,
      );
    }
  }

  @override
  Future<List<ChatMessage>> getOlderMessages({
    required String conversationId,
    required DateTime before,
    int limit = 20,
  }) async {
    try {
      final snapshot = await _messages(conversationId)
          .orderBy('sentAt', descending: true)
          .where('sentAt', isLessThan: Timestamp.fromDate(before))
          .limit(limit)
          .get();

      final messages = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), id: doc.id))
          .toList();
      return messages.reversed.toList();
    } on FirebaseException catch (e) {
      throw ChatServiceException(
        'Failed to fetch older messages for conversation $conversationId',
        cause: e,
      );
    }
  }

  @override
  Future<List<ConversationModel>> getAllConversations(String userId) async {
    try {
      // Fetch conversations where the provider OR customer is `userId`.
      // Firestore doesn't support OR across fields natively, so we run
      // two queries and merge — a common pattern.
      final results = await Future.wait([
        _conversations
            .where('providerId', isEqualTo: userId)
            .orderBy('lastActivityAt', descending: true)
            .get(),
        _conversations
            .where('customerId', isEqualTo: userId)
            .orderBy('lastActivityAt', descending: true)
            .get(),
      ]);

      final seen = <String>{};
      final conversations = <ConversationModel>[];

      for (final snapshot in results) {
        for (final doc in snapshot.docs) {
          if (seen.add(doc.id)) {
            conversations.add(
              ConversationModel.fromMap(doc.data(), id: doc.id),
            );
          }
        }
      }

      // Sort merged list by lastActivityAt descending.
      conversations.sort(
        (a, b) => (b.lastActivityAt ?? b.createdAt).compareTo(
          a.lastActivityAt ?? a.createdAt,
        ),
      );

      return conversations;
    } on FirebaseException catch (e) {
      throw ChatServiceException(
        'Failed to fetch conversations for user $userId',
        cause: e,
      );
    }
  }

  @override
  Future<ConversationModel?> getConversation(String conversationId) async {
    try {
      final doc = await _conversations.doc(conversationId).get();
      if (!doc.exists || doc.data() == null) return null;
      return ConversationModel.fromMap(doc.data()!, id: doc.id);
    } on FirebaseException catch (e) {
      throw ChatServiceException(
        'Failed to fetch conversation $conversationId',
        cause: e,
      );
    }
  }

  // ── Real-time streams ──────────────────────────────────────────────────────

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    return _messages(conversationId)
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromMap(doc.data(), id: doc.id))
              .toList(),
        )
        .handleError((Object error) {
          throw ChatServiceException(
            'Stream error for conversation $conversationId',
            cause: error,
          );
        });
  }

  @override
  Stream<List<ConversationModel>> watchConversations(String userId) {
    // Merge two streams (provider + customer) into one sorted stream.
    final providerStream = _conversations
        .where('providerId', isEqualTo: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots();

    final customerStream = _conversations
        .where('customerId', isEqualTo: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots();

    return _mergeConversationStreams(providerStream, customerStream);
  }

  Stream<List<ConversationModel>> _mergeConversationStreams(
    Stream<QuerySnapshot<Map<String, dynamic>>> a,
    Stream<QuerySnapshot<Map<String, dynamic>>> b,
  ) {
    // Keep the latest snapshot from each stream and re-emit when either fires.
    QuerySnapshot<Map<String, dynamic>>? latestA;
    QuerySnapshot<Map<String, dynamic>>? latestB;
    late StreamController<List<ConversationModel>> controller;

    void emit() {
      if (latestA == null || latestB == null) return;
      final seen = <String>{};
      final list = <ConversationModel>[];
      for (final doc in [...latestA!.docs, ...latestB!.docs]) {
        if (seen.add(doc.id)) {
          list.add(ConversationModel.fromMap(doc.data(), id: doc.id));
        }
      }
      list.sort(
        (x, y) => (y.lastActivityAt ?? y.createdAt).compareTo(
          x.lastActivityAt ?? x.createdAt,
        ),
      );
      controller.add(list);
    }

    controller = StreamController<List<ConversationModel>>.broadcast(
      onListen: () {
        a.listen((snap) {
          latestA = snap;
          emit();
        });
        b.listen((snap) {
          latestB = snap;
          emit();
        });
      },
    );

    return controller.stream;
  }

  // ── Mutations ──────────────────────────────────────────────────────────────

  @override
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final now = DateTime.now();
      final msgRef = _messages(conversationId).doc(); // auto-id

      final message = ChatMessage(
        id: msgRef.id,
        text: text.trim(),
        sentAt: now,
        senderId: senderId,
        receiverId: receiverId,
        conversationId: conversationId,
        deliveryStatus: MessageDeliveryStatus.sent,
      );

      // Write message + update conversation metadata atomically.
      final batch = _db.batch();

      batch.set(msgRef, message.toMap());

      batch.update(_conversations.doc(conversationId), {
        'lastActivityAt': Timestamp.fromDate(now),
        'unreadCount': FieldValue.increment(1),
        'lastMessageText': text.trim(),
      });

      await batch.commit();
      return message;
    } on FirebaseException catch (e) {
      throw ChatServiceException('Failed to send message', cause: e);
    }
  }

  @override
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String currentUserId,
  }) async {
    try {
      // Find all unread messages NOT sent by the current user.
      final snapshot = await _messages(conversationId)
          .where('receiverId', isEqualTo: currentUserId)
          .where(
            'deliveryStatus',
            isNotEqualTo: MessageDeliveryStatus.read.value,
          )
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _db.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'deliveryStatus': MessageDeliveryStatus.read.value,
        });
      }

      // Reset unread counter.
      batch.update(_conversations.doc(conversationId), {'unreadCount': 0});

      await batch.commit();
    } on FirebaseException catch (e) {
      throw ChatServiceException('Failed to mark messages as read', cause: e);
    }
  }

  @override
  Future<void> updateConversationStatus({
    required String conversationId,
    required ConversationStatus status,
  }) async {
    try {
      await _conversations.doc(conversationId).update({'status': status.value});
    } on FirebaseException catch (e) {
      throw ChatServiceException(
        'Failed to update conversation status',
        cause: e,
      );
    }
  }

  @override
  Future<ConversationModel?> findConversation({
    required String providerId,
    required String customerId,
    required String serviceId,
  }) async {
    try {
      // نضع الـ timeout هنا مباشرة على طلبات الفايرستور لحمايتها
      final results =
          await Future.wait([
            _conversations
                .where('providerId', isEqualTo: providerId)
                .where('customerId', isEqualTo: customerId)
                .get(),
            _conversations
                .where('providerId', isEqualTo: customerId)
                .where('customerId', isEqualTo: providerId)
                .get(),
          ]).timeout(
            const Duration(seconds: 10),
          ); // إذا علق الفايرستور بسبب الفهرس، سينفجر الخطأ بعد 10 ثوانٍ

      for (final snapshot in results) {
        for (final doc in snapshot.docs) {
          final conversation = ConversationModel.fromMap(
            doc.data(),
            id: doc.id,
          );
          if (conversation.serviceId == serviceId) {
            return conversation;
          }
        }
      }

      return null;
    } on FirebaseException catch (e) {
      throw ChatServiceException('Failed to find conversation', cause: e);
    }
  }

  @override
  Future<ConversationModel> createConversation(
    ConversationModel conversation,
  ) async {
    try {
      final ref = conversation.id.isEmpty
          ? _conversations
                .doc() // auto-id
          : _conversations.doc(conversation.id);

      final model = conversation.id.isEmpty
          ? conversation.copyWith(id: ref.id)
          : conversation;

      await ref.set(model.toMap());
      return model;
    } on FirebaseException catch (e) {
      throw ChatServiceException('Failed to create conversation', cause: e);
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      // Delete subcollection messages first (Firestore doesn't cascade).
      final messages = await _messages(conversationId).get();
      final batch = _db.batch();
      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(_conversations.doc(conversationId));
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ChatServiceException('Failed to delete conversation', cause: e);
    }
  }
}
