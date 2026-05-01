import 'package:flutter_test/flutter_test.dart';
import 'package:skillbridge/core/utils/services/notifications/notification_route_intent.dart';
import 'package:skillbridge/features/messages/data/messages_mock_data.dart';

void main() {
  group('Notification payload routing', () {
    test('routes a message payload with conversation id to chat detail', () {
      final intent = NotificationRouteIntent.fromData({
        'type': 'message',
        'conversationId': 'conv-2',
      });

      expect(intent.target, NotificationRouteTarget.messageConversation);
      expect(intent.conversationId, 'conv-2');
      expect(
        findSeedConversationById(intent.conversationId)?.customerName,
        'Omar Nabil',
      );
    });

    test('routes a message payload without conversation id to inbox', () {
      final intent = NotificationRouteIntent.fromData({'type': 'message'});

      expect(intent.target, NotificationRouteTarget.messagesInbox);
      expect(intent.conversationId, isNull);
    });

    test('falls back to home for unknown notification types', () {
      final intent = NotificationRouteIntent.fromData({'type': 'unknown_type'});

      expect(intent.target, NotificationRouteTarget.home);
    });
  });
}
