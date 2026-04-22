part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

final class MessagesLoaded extends MessagesState {
  final List<ServiceConversation> conversations;
  final MessageFilter selectedFilter;
  final String searchQuery;
  final String? activeConversationId;
  final bool isSendingMessage;

  MessagesLoaded({
    required this.conversations,
    this.selectedFilter = MessageFilter.all,
    this.searchQuery = '',
    this.activeConversationId,
    this.isSendingMessage = false,
  });

  MessagesLoaded copyWith({
    List<ServiceConversation>? conversations,
    MessageFilter? selectedFilter,
    String? searchQuery,
    String? activeConversationId,
    bool? isSendingMessage,
  }) {
    return MessagesLoaded(
      conversations: conversations ?? this.conversations,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      activeConversationId: activeConversationId ?? this.activeConversationId,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
    );
  }

  List<ServiceConversation> get visibleConversations {
    final query = searchQuery.trim().toLowerCase();

    return conversations.where((conversation) {
      final matchesFilter = switch (selectedFilter) {
        MessageFilter.all => true,
        MessageFilter.newLeads =>
          conversation.status == ConversationStatus.newLead,
        MessageFilter.active =>
          conversation.status == ConversationStatus.active,
        MessageFilter.waiting =>
          conversation.status == ConversationStatus.waiting,
        MessageFilter.archived =>
          conversation.status == ConversationStatus.archived,
      };

      final matchesSearch =
          query.isEmpty ||
          conversation.customerName.toLowerCase().contains(query) ||
          conversation.serviceTitle.toLowerCase().contains(query) ||
          conversation.serviceCategory.label.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  ServiceConversation? get activeConversation {
    if (activeConversationId == null) return null;
    for (final conversation in conversations) {
      if (conversation.id == activeConversationId) return conversation;
    }
    return null;
  }
}

final class MessagesError extends MessagesState {
  final String message;

  MessagesError(this.message);
}
