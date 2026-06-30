import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';

enum ConversationStatus { newLead, active, waiting, closed }

extension ConversationStatusX on ConversationStatus {
  String get value => name;

  static ConversationStatus fromString(String? value) {
    return ConversationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ConversationStatus.newLead,
    );
  }
}

enum MessageFilter { all, newLeads, active, waiting }

class ConversationModel {
  final String id;

  // Participant info
  final String providerId;
  final String customerId;
  final String customerName;
  final String customerHandle;
  final String? customerAvatarUrl;

  // Service info
  final String serviceId;
  final String serviceTitle;
  final String serviceSummary;
  final AdCategories serviceCategory;
  final AdCity serviceCity;
  final double servicePrice;

  // State
  final ConversationStatus status;
  final int unreadCount;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime? lastActivityAt;

  // Messages — kept lazy: loaded separately via ChatService
  final List<ChatMessage> messages;

  const ConversationModel({
    required this.id,
    required this.providerId,
    required this.customerId,
    required this.customerName,
    required this.customerHandle,
    this.customerAvatarUrl,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceSummary,
    required this.serviceCategory,
    required this.serviceCity,
    required this.servicePrice,
    required this.status,
    required this.unreadCount,
    required this.isOnline,
    required this.createdAt,
    this.lastActivityAt,
    this.messages = const [],
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  factory ConversationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    return ConversationModel(
      id: id ?? map['id'] as String,
      providerId: map['providerId'] as String? ?? '',
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      customerHandle: map['customerHandle'] as String,
      customerAvatarUrl: map['customerAvatarUrl'] as String?,
      serviceId: map['serviceId'] as String,
      serviceTitle: map['serviceTitle'] as String,
      serviceSummary: map['serviceSummary'] as String,
      serviceCategory: AdCategories.values.firstWhere(
        (e) => e.name == map['serviceCategory'],
        orElse: () => AdCategories.values.first,
      ),
      serviceCity: AdCity.values.firstWhere(
        (e) => e.name == map['serviceCity'],
        orElse: () => AdCity.values.first,
      ),
      servicePrice: (map['servicePrice'] as num).toDouble(),
      status: ConversationStatusX.fromString(map['status'] as String?),
      unreadCount: (map['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: map['isOnline'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
      lastActivityAt: map['lastActivityAt'] != null
          ? parseDate(map['lastActivityAt'])
          : null,
      // messages are loaded separately — not stored in this map
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'providerId': providerId,
    'customerId': customerId,
    'customerName': customerName,
    'customerHandle': customerHandle,
    if (customerAvatarUrl != null) 'customerAvatarUrl': customerAvatarUrl,
    'serviceId': serviceId,
    'serviceTitle': serviceTitle,
    'serviceSummary': serviceSummary,
    'serviceCategory': serviceCategory.name,
    'serviceCity': serviceCity.name,
    'servicePrice': servicePrice,
    'status': status.value,
    'unreadCount': unreadCount,
    'isOnline': isOnline,
    'createdAt': Timestamp.fromDate(createdAt),
    if (lastActivityAt != null)
      'lastActivityAt': Timestamp.fromDate(lastActivityAt!),
  };

  // ── Derived ────────────────────────────────────────────────────────────────

  ChatMessage? get latestMessage => messages.isEmpty ? null : messages.last;

  bool get hasUnread => unreadCount > 0;

  bool matchesFilter(MessageFilter filter) => switch (filter) {
    MessageFilter.all => true,
    MessageFilter.newLeads => status == ConversationStatus.newLead,
    MessageFilter.active => status == ConversationStatus.active,
    MessageFilter.waiting => status == ConversationStatus.waiting,
  };

  // ── copyWith ───────────────────────────────────────────────────────────────

  ConversationModel copyWith({
    String? id,
    String? providerId,
    String? customerId,
    String? customerName,
    String? customerHandle,
    String? customerAvatarUrl,
    String? serviceId,
    String? serviceTitle,
    String? serviceSummary,
    AdCategories? serviceCategory,
    AdCity? serviceCity,
    double? servicePrice,
    ConversationStatus? status,
    int? unreadCount,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    List<ChatMessage>? messages,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerHandle: customerHandle ?? this.customerHandle,
      customerAvatarUrl: customerAvatarUrl ?? this.customerAvatarUrl,
      serviceId: serviceId ?? this.serviceId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      serviceSummary: serviceSummary ?? this.serviceSummary,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceCity: serviceCity ?? this.serviceCity,
      servicePrice: servicePrice ?? this.servicePrice,
      status: status ?? this.status,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messages: messages ?? this.messages,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ConversationModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
