import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/service_conversation.dart';

/// Builds the seed inbox used by the messaging UI and notification tests.
List<ServiceConversation> buildSeedConversations() {
  return [
    ServiceConversation(
      id: 'conv-1',
      customerName: 'Lina Hassan',
      customerHandle: '@linah',
      serviceTitle: 'Brand Identity Design',
      serviceSummary: 'Logo package, brand colors, and social kit.',
      serviceCategory: AdCategories.fashion,
      serviceCity: AdCity.cairo,
      servicePrice: 1200,
      status: ConversationStatus.newLead,
      unreadCount: 2,
      isOnline: true,
      messages: [
        ChatMessage(
          id: 'msg-1',
          text:
              'Hi, are you available to design a full logo package this week?',
          sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
          isFromCurrentUser: false,
          deliveryStatus: MessageDeliveryStatus.read,
        ),
        ChatMessage(
          id: 'msg-2',
          text: 'Yes, I can do that. Do you already have a style direction?',
          sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
          isFromCurrentUser: true,
          deliveryStatus: MessageDeliveryStatus.read,
        ),
        ChatMessage(
          id: 'msg-3',
          text:
              'I want something clean and premium. Can I send references here?',
          sentAt: DateTime.now().subtract(const Duration(minutes: 4)),
          isFromCurrentUser: false,
        ),
      ],
    ),
    ServiceConversation(
      id: 'conv-2',
      customerName: 'Omar Nabil',
      customerHandle: '@omar_n',
      serviceTitle: 'Math Tutoring (K-12)',
      serviceSummary: 'Weekly algebra and calculus support sessions.',
      serviceCategory: AdCategories.education,
      serviceCity: AdCity.giza,
      servicePrice: 350,
      status: ConversationStatus.active,
      unreadCount: 0,
      isOnline: false,
      messages: [
        ChatMessage(
          id: 'msg-4',
          text: 'Can we lock our next session for Thursday at 7 PM?',
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
          isFromCurrentUser: false,
          deliveryStatus: MessageDeliveryStatus.read,
        ),
        ChatMessage(
          id: 'msg-5',
          text: 'Thursday works. I will prepare the trigonometry worksheet.',
          sentAt: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 45),
          ),
          isFromCurrentUser: true,
          deliveryStatus: MessageDeliveryStatus.read,
        ),
      ],
    ),
    ServiceConversation(
      id: 'conv-3',
      customerName: 'Mariam Adel',
      customerHandle: '@mariam.a',
      serviceTitle: 'Deep Home Cleaning',
      serviceSummary: 'One-time apartment deep clean with supplies included.',
      serviceCategory: AdCategories.services,
      serviceCity: AdCity.alexandria,
      servicePrice: 900,
      status: ConversationStatus.waiting,
      unreadCount: 1,
      isOnline: true,
      messages: [
        ChatMessage(
          id: 'msg-6',
          text:
              'I sent the building address. Waiting for your final confirmation.',
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          isFromCurrentUser: false,
        ),
      ],
    ),
    ServiceConversation(
      id: 'conv-4',
      customerName: 'Youssef Samir',
      customerHandle: '@youssef',
      serviceTitle: 'Laptop Repair & Setup',
      serviceSummary: 'Diagnostics, cleanup, and fresh software installation.',
      serviceCategory: AdCategories.electronics,
      serviceCity: AdCity.cairo,
      servicePrice: 500,
      status: ConversationStatus.archived,
      unreadCount: 0,
      isOnline: false,
      messages: [
        ChatMessage(
          id: 'msg-7',
          text: 'Thanks again. The machine is running perfectly now.',
          sentAt: DateTime.now().subtract(const Duration(days: 5)),
          isFromCurrentUser: false,
          deliveryStatus: MessageDeliveryStatus.read,
        ),
      ],
    ),
  ];
}

/// Finds a seeded conversation by id for routing and local notification tests.
ServiceConversation? findSeedConversationById(String? id) {
  if (id == null || id.isEmpty) return null;

  for (final conversation in buildSeedConversations()) {
    if (conversation.id == id) {
      return conversation;
    }
  }

  return null;
}
