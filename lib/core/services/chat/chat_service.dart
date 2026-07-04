import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

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
