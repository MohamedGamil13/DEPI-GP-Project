import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageDeliveryStatus { sent, delivered, read }

extension MessageDeliveryStatusX on MessageDeliveryStatus {
  String get value => name; // 'sent' | 'delivered' | 'read'

  static MessageDeliveryStatus fromString(String? value) {
    return MessageDeliveryStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MessageDeliveryStatus.sent,
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final DateTime sentAt;
  final String senderId;
  final String receiverId;
  final String conversationId;
  final MessageDeliveryStatus deliveryStatus;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  factory ChatMessage.fromMap(Map<String, dynamic> map, {String? id}) {
    return ChatMessage(
      id: id ?? map['id'] as String,
      text: map['text'] as String,
      sentAt: (map['sentAt'] is Timestamp)
          ? (map['sentAt'] as Timestamp).toDate()
          : DateTime.parse(map['sentAt'] as String),
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      conversationId: map['conversationId'] as String,
      deliveryStatus: MessageDeliveryStatusX.fromString(
        map['deliveryStatus'] as String?,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'sentAt': Timestamp.fromDate(sentAt),
    'senderId': senderId,
    'receiverId': receiverId,
    'conversationId': conversationId,
    'deliveryStatus': deliveryStatus.value,
  };

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool isFromCurrentUser(String currentUserId) => senderId == currentUserId;

  bool get isRead => deliveryStatus == MessageDeliveryStatus.read;

  // ── copyWith ───────────────────────────────────────────────────────────────

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? sentAt,
    String? senderId,
    String? receiverId,
    String? conversationId,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      conversationId: conversationId ?? this.conversationId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ChatMessage && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ChatMessage(id: $id, senderId: $senderId, status: ${deliveryStatus.name})';
}
