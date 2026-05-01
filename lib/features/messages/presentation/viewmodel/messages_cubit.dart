import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/messages/data/messages_mock_data.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/service_conversation.dart';

part 'messages_state.dart';

/// Manages inbox filters, active conversation selection, and local send actions.
class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  /// Loads the seeded inbox used by the current messaging feature.
  void loadInbox() {
    emit(MessagesLoading());
    emit(
      MessagesLoaded(
        conversations: List<ServiceConversation>.from(buildSeedConversations()),
      ),
    );
  }

  /// Loads a single conversation as the current detail context.
  void loadConversation(ServiceConversation conversation) {
    emit(
      MessagesLoaded(
        conversations: [conversation.copyWith(unreadCount: 0)],
        activeConversationId: conversation.id,
      ),
    );
  }

  /// Applies the selected inbox filter.
  void selectFilter(MessageFilter filter) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(selectedFilter: filter));
  }

  /// Updates the inbox search query.
  void updateSearchQuery(String query) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(searchQuery: query));
  }

  /// Marks a conversation as opened and clears its unread count.
  void openConversation(String conversationId) {
    final current = state;
    if (current is! MessagesLoaded) return;

    final updatedConversations = current.conversations
        .map(
          (conversation) => conversation.id == conversationId
              ? conversation.copyWith(unreadCount: 0)
              : conversation,
        )
        .toList();

    emit(
      current.copyWith(
        conversations: updatedConversations,
        activeConversationId: conversationId,
      ),
    );
  }

  /// Appends a local outgoing message to the active conversation.
  Future<void> sendMessage(String text) async {
    final current = state;
    if (current is! MessagesLoaded || current.activeConversation == null) {
      return;
    }

    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    emit(current.copyWith(isSendingMessage: true));

    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmedText,
      sentAt: DateTime.now(),
      isFromCurrentUser: true,
    );

    final updatedConversation = current.activeConversation!.copyWith(
      status: ConversationStatus.active,
      messages: [...current.activeConversation!.messages, message],
    );

    final updatedConversations = current.conversations
        .map(
          (conversation) => conversation.id == updatedConversation.id
              ? updatedConversation
              : conversation,
        )
        .toList();

    emit(
      current.copyWith(
        conversations: _sortConversations(updatedConversations),
        activeConversationId: updatedConversation.id,
        isSendingMessage: false,
      ),
    );
  }

  List<ServiceConversation> _sortConversations(
    List<ServiceConversation> conversations,
  ) {
    final sorted = List<ServiceConversation>.from(conversations);
    sorted.sort((a, b) {
      final aTime =
          a.latestMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          b.latestMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }
}
