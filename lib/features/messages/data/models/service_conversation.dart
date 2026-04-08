import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';

enum ConversationStatus { newLead, active, waiting, archived }

enum MessageFilter { all, newLeads, active, waiting, archived }

class ServiceConversation {
  final String id;
  final String customerName;
  final String customerHandle;
  final String serviceTitle;
  final String serviceSummary;
  final AdCategories serviceCategory;
  final AdCity serviceCity;
  final double servicePrice;
  final ConversationStatus status;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessage> messages;

  const ServiceConversation({
    required this.id,
    required this.customerName,
    required this.customerHandle,
    required this.serviceTitle,
    required this.serviceSummary,
    required this.serviceCategory,
    required this.serviceCity,
    required this.servicePrice,
    required this.status,
    required this.unreadCount,
    required this.isOnline,
    required this.messages,
  });

  ServiceConversation copyWith({
    String? id,
    String? customerName,
    String? customerHandle,
    String? serviceTitle,
    String? serviceSummary,
    AdCategories? serviceCategory,
    AdCity? serviceCity,
    double? servicePrice,
    ConversationStatus? status,
    int? unreadCount,
    bool? isOnline,
    List<ChatMessage>? messages,
  }) {
    return ServiceConversation(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerHandle: customerHandle ?? this.customerHandle,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      serviceSummary: serviceSummary ?? this.serviceSummary,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceCity: serviceCity ?? this.serviceCity,
      servicePrice: servicePrice ?? this.servicePrice,
      status: status ?? this.status,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      messages: messages ?? this.messages,
    );
  }

  ChatMessage? get latestMessage => messages.isEmpty ? null : messages.last;
}
