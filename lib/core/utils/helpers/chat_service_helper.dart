import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

class ChatServiceHelper {
  ChatMessage mapMessage(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatMessage.fromMap(doc.data(), id: doc.id);
  }

  List<ChatMessage> mapMessages(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map(mapMessage).toList();
  }

  ConversationModel mapConversation(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return ConversationModel.fromMap(doc.data(), id: doc.id);
  }

  List<ConversationModel> dedupeAndSortConversations(
    List<QuerySnapshot<Map<String, dynamic>>> results,
  ) {
    final seen = <String>{};
    final conversations = <ConversationModel>[];

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        if (seen.add(doc.id)) {
          conversations.add(ConversationModel.fromMap(doc.data(), id: doc.id));
        }
      }
    }

    conversations.sort(
      (a, b) => (b.lastActivityAt ?? b.createdAt).compareTo(
        a.lastActivityAt ?? a.createdAt,
      ),
    );

    return conversations;
  }

  Stream<List<ConversationModel>> mergeConversationStreams(
    Stream<QuerySnapshot<Map<String, dynamic>>> a,
    Stream<QuerySnapshot<Map<String, dynamic>>> b,
  ) {
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
}
