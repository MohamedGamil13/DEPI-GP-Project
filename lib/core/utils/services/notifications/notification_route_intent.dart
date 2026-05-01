/// High-level destinations supported by notification payload routing.
enum NotificationRouteTarget {
  home,
  messagesInbox,
  messageConversation,
  profile,
}

/// Parsed navigation intent derived from notification data.
class NotificationRouteIntent {
  final NotificationRouteTarget target;
  final String? conversationId;

  const NotificationRouteIntent({required this.target, this.conversationId});

  /// Maps a notification payload into an in-app navigation target.
  factory NotificationRouteIntent.fromData(Map<String, dynamic> data) {
    final type = data['type']?.toString().trim().toLowerCase();
    final conversationId = data['conversationId']?.toString();

    return switch (type) {
      'message' when conversationId != null && conversationId.isNotEmpty =>
        NotificationRouteIntent(
          target: NotificationRouteTarget.messageConversation,
          conversationId: conversationId,
        ),
      'message' => const NotificationRouteIntent(
        target: NotificationRouteTarget.messagesInbox,
      ),
      'profile' => const NotificationRouteIntent(
        target: NotificationRouteTarget.profile,
      ),
      _ => const NotificationRouteIntent(target: NotificationRouteTarget.home),
    };
  }
}
