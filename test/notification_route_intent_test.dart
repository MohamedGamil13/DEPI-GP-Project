import 'package:flutter_test/flutter_test.dart';
import 'package:skillbridge/core/services/notifications/notification_route_intent.dart';

void main() {
  group('NotificationRouteIntent.fromData', () {
    test('message with conversationId → messageConversation', () {
      final intent = NotificationRouteIntent.fromData({
        'type': 'message',
        'conversationId': 'conv-123',
      });
      expect(intent.target, NotificationRouteTarget.messageConversation);
      expect(intent.conversationId, 'conv-123');
    });

    test('message without conversationId → messagesInbox', () {
      final intent = NotificationRouteIntent.fromData({'type': 'message'});
      expect(intent.target, NotificationRouteTarget.messagesInbox);
    });

    test('listing with adId → listingDetail', () {
      final intent = NotificationRouteIntent.fromData({
        'type': 'listing',
        'adId': '42',
      });
      expect(intent.target, NotificationRouteTarget.listingDetail);
      expect(intent.adId, 42);
    });

    test('listing without adId → home', () {
      final intent = NotificationRouteIntent.fromData({'type': 'listing'});
      expect(intent.target, NotificationRouteTarget.home);
    });

    test('profile → profile', () {
      final intent = NotificationRouteIntent.fromData({'type': 'profile'});
      expect(intent.target, NotificationRouteTarget.profile);
    });

    test('unknown type → home', () {
      final intent = NotificationRouteIntent.fromData({'type': 'gibberish'});
      expect(intent.target, NotificationRouteTarget.home);
    });

    test('empty payload → home', () {
      final intent = NotificationRouteIntent.fromData({});
      expect(intent.target, NotificationRouteTarget.home);
    });

    test('type is case-insensitive', () {
      final intent = NotificationRouteIntent.fromData({
        'type': '  MESSAGE  ',
        'conversationId': 'conv-1',
      });
      expect(intent.target, NotificationRouteTarget.messageConversation);
    });
  });
}
