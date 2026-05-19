enum MessageDeliveryStatus { sent, read }

class ChatMessage {
  final String id;
  final String text;
  final DateTime sentAt;
  final String senderId;
  final String receiverId;

  final MessageDeliveryStatus deliveryStatus;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? sentAt,
    String? senderId,
    String? receiverId,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }
}
