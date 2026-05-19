import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({required IChatService chatService})
    : _service = chatService,
      super(MessagesInitial());

  final IChatService _service;

  // Live subscriptions — cancelled on close()
  StreamSubscription<List<ConversationModel>>? _conversationsSub;
  StreamSubscription<List<ChatMessage>>? _messagesSub;

  // ── Inbox ──────────────────────────────────────────────────────────────────

  /// Subscribe to the user's inbox in real time.
  void loadInbox(String userId) {
    emit(MessagesLoading());

    _conversationsSub?.cancel();
    _conversationsSub = _service.watchConversations(userId).listen(
      (conversations) {
        final current = state;
        if (current is MessagesLoaded) {
          emit(current.copyWith(conversations: conversations));
        } else {
          emit(MessagesLoaded(conversations: conversations));
        }
      },
      onError: (Object e) =>
          emit(MessagesError('Failed to load inbox: ${e.toString()}')),
    );
  }

  // ── Filters & search ───────────────────────────────────────────────────────

  void selectFilter(MessageFilter filter) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(selectedFilter: filter));
  }

  void updateSearchQuery(String query) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(searchQuery: query));
  }

  // ── Open / close conversation ──────────────────────────────────────────────

  /// Opens a conversation, marks messages as read, and subscribes to its
  /// message stream so [activeConversation.messages] stays live.
  Future<void> openConversation({
    required String conversationId,
    required String currentUserId,
  }) async {
    final current = state;
    if (current is! MessagesLoaded) return;

    // Optimistically zero the badge.
    final updatedConversations = current.conversations
        .map((c) => c.id == conversationId ? c.copyWith(unreadCount: 0) : c)
        .toList();

    emit(
      current.copyWith(
        conversations: updatedConversations,
        activeConversationId: conversationId,
      ),
    );

    // Mark as read in Firestore (fire-and-forget).
    _service
        .markMessagesAsRead(
          conversationId: conversationId,
          currentUserId: currentUserId,
        )
        .ignore();

    // Subscribe to live messages for this conversation.
    _messagesSub?.cancel();
    _messagesSub = _service
        .watchMessages(conversationId)
        .listen(
          (messages) {
            final s = state;
            if (s is! MessagesLoaded) return;

            final refreshed = s.conversations.map((c) {
              return c.id == conversationId
                  ? c.copyWith(messages: messages)
                  : c;
            }).toList();

            emit(s.copyWith(conversations: refreshed));
          },
          onError: (Object e) {
            // Non-fatal — just log; don't replace inbox state with an error.
            debugPrint('Message stream error: $e');
          },
        );
  }

  void closeConversation() {
    _messagesSub?.cancel();
    _messagesSub = null;

    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(clearActiveConversation: true));
  }

  // ── Send ───────────────────────────────────────────────────────────────────

  Future<void> sendMessage({
    required String text,
    required String senderId,
  }) async {
    final current = state;
    if (current is! MessagesLoaded || current.activeConversation == null) {
      return;
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final conversation = current.activeConversation!;

    emit(current.copyWith(isSendingMessage: true));

    try {
      await _service.sendMessage(
        conversationId: conversation.id,
        text: trimmed,
        senderId: senderId,
        receiverId: conversation.customerId,
      );
      // The message stream will push the new message automatically.
    } on ChatServiceException catch (e) {
      debugPrint('Send failed: $e');
      // Restore non-sending state without showing a full error screen.
    } finally {
      final s = state;
      if (s is MessagesLoaded) {
        emit(s.copyWith(isSendingMessage: false));
      }
    }
  }

  // ── Conversation status ────────────────────────────────────────────────────

  Future<void> updateStatus({
    required String conversationId,
    required ConversationStatus status,
  }) async {
    try {
      await _service.updateConversationStatus(
        conversationId: conversationId,
        status: status,
      );
      // Stream will emit the update.
    } on ChatServiceException catch (e) {
      debugPrint('Status update failed: $e');
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _conversationsSub?.cancel();
    _messagesSub?.cancel();
    return super.close();
  }
}
