enum MessageDeliveryStatus { sent, read }

class ChatMessage {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isFromCurrentUser;
  final MessageDeliveryStatus deliveryStatus;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isFromCurrentUser,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? sentAt,
    bool? isFromCurrentUser,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isFromCurrentUser: isFromCurrentUser ?? this.isFromCurrentUser,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }
}
