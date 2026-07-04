import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/utils/helpers/chat_service_helper.dart';
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

class ChatService implements IChatService {
  ChatService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  final ChatServiceHelper _helper = ChatServiceHelper();

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

      return _helper.mapMessages(snapshot);
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

      final messages = _helper.mapMessages(snapshot);
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

      return _helper.dedupeAndSortConversations(results);
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
        .map(_helper.mapMessages)
        .handleError((Object error) {
          throw ChatServiceException(
            'Stream error for conversation $conversationId',
            cause: error,
          );
        });
  }

  @override
  Stream<List<ConversationModel>> watchConversations(String userId) {
    final providerStream = _conversations
        .where('providerId', isEqualTo: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots();

    final customerStream = _conversations
        .where('customerId', isEqualTo: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots();

    return _helper.mergeConversationStreams(providerStream, customerStream);
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
          final conversation = _helper.mapConversation(doc);
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
