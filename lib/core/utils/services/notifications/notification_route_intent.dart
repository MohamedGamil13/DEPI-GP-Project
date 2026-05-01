/// High-level destinations supported by notification payload routing.
enum NotificationRouteTarget {
  home,
  messagesInbox,
  messageConversation,
  listingDetail,
  profile,
}

/// Parsed navigation intent derived from notification data.
class NotificationRouteIntent {
  final NotificationRouteTarget target;
  final String? conversationId;
  final int? adId;

  const NotificationRouteIntent({
    required this.target,
    this.conversationId,
    this.adId,
  });

  /// Maps a notification payload into an in-app navigation target.
  factory NotificationRouteIntent.fromData(Map<String, dynamic> data) {
    final type = data['type']?.toString().trim().toLowerCase();
    final conversationId = data['conversationId']?.toString();
    final adId = int.tryParse(data['adId']?.toString() ?? '');

    return switch (type) {
      'message' when conversationId != null && conversationId.isNotEmpty =>
        NotificationRouteIntent(
          target: NotificationRouteTarget.messageConversation,
          conversationId: conversationId,
        ),
      'message' => const NotificationRouteIntent(
        target: NotificationRouteTarget.messagesInbox,
      ),
      'listing' when adId != null => NotificationRouteIntent(
        target: NotificationRouteTarget.listingDetail,
        adId: adId,
      ),
      'listing' => const NotificationRouteIntent(
        target: NotificationRouteTarget.home,
      ),
      'profile' => const NotificationRouteIntent(
        target: NotificationRouteTarget.profile,
      ),
      _ => const NotificationRouteIntent(target: NotificationRouteTarget.home),
    };
  }
}
