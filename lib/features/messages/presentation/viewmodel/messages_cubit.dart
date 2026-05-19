import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  void loadInbox() {
    emit(MessagesLoading());
    emit(
      MessagesLoaded(
        conversations: List<ConversationModel>.from(_seedConversations),
      ),
    );
  }

  void loadConversation(ConversationModel conversation) {
    emit(
      MessagesLoaded(
        conversations: [conversation.copyWith(unreadCount: 0)],
        activeConversationId: conversation.id,
      ),
    );
  }

  void selectFilter(MessageFilter filter) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(selectedFilter: filter));
  }

  void updateSearchQuery(String query) {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(searchQuery: query));
  }

  void openConversation(String conversationId) {
    final current = state;
    if (current is! MessagesLoaded) return;

    final updatedConversations = current.conversations
        .map(
          (conversation) => conversation.id == conversationId
              ? conversation.copyWith(unreadCount: 0)
              : conversation,
        )
        .toList();

    emit(
      current.copyWith(
        conversations: updatedConversations,
        activeConversationId: conversationId,
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    final current = state;
    if (current is! MessagesLoaded || current.activeConversation == null) {
      return;
    }

    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    emit(current.copyWith(isSendingMessage: true));

    // final message = ChatMessage(
    //   id: DateTime.now().microsecondsSinceEpoch.toString(),
    //   text: trimmedText,
    //   sentAt: DateTime.now(),
    //   isFromCurrentUser: true,
    // );

    final updatedConversation = current.activeConversation!.copyWith(
      status: ConversationStatus.active,
      messages: [],
      //  [...current.activeConversation!.messages, message]   ,
    );

    final updatedConversations = current.conversations
        .map(
          (conversation) => conversation.id == updatedConversation.id
              ? updatedConversation
              : conversation,
        )
        .toList();

    emit(
      current.copyWith(
        conversations: _sortConversations(updatedConversations),
        activeConversationId: updatedConversation.id,
        isSendingMessage: false,
      ),
    );
  }

  List<ConversationModel> _sortConversations(
    List<ConversationModel> conversations,
  ) {
    final sorted = List<ConversationModel>.from(conversations);
    sorted.sort((a, b) {
      final aTime =
          a.latestMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          b.latestMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }
}

final List<ConversationModel> _seedConversations = [
  const ConversationModel(
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
      // ChatMessage(
      //   id: 'msg-1',
      //   text: 'Hi, are you available to design a full logo package this week?',
      //   sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
      //   isFromCurrentUser: false,
      //   deliveryStatus: MessageDeliveryStatus.read,
      // ),
      // ChatMessage(
      //   id: 'msg-2',
      //   text: 'Yes, I can do that. Do you already have a style direction?',
      //   sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
      //   isFromCurrentUser: true,
      //   deliveryStatus: MessageDeliveryStatus.read,
      // ),
      // ChatMessage(
      //   id: 'msg-3',
      //   text: 'I want something clean and premium. Can I send references here?',
      //   sentAt: DateTime.now().subtract(const Duration(minutes: 4)),
      //   isFromCurrentUser: false,
      // ),
    ],
  ),
  const ConversationModel(
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
    messages: [],
  ),

  // [
  //   ChatMessage(
  //     id: 'msg-4',
  //     text: 'Can we lock our next session for Thursday at 7 PM?',
  //     sentAt: DateTime.now().subtract(const Duration(hours: 3)),
  //     isFromCurrentUser: false,
  //     deliveryStatus: MessageDeliveryStatus.read,
  //   ),
  //   ChatMessage(
  //     id: 'msg-5',
  //     text: 'Thursday works. I will prepare the trigonometry worksheet.',
  //     sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
  //     isFromCurrentUser: true,
  //     deliveryStatus: MessageDeliveryStatus.read,
  //   ),
  // ],
  //  ),
  const ConversationModel(
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
      // ChatMessage(
      //   id: 'msg-6',
      //   text:
      //       'I sent the building address. Waiting for your final confirmation.',
      //   sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      //   isFromCurrentUser: false,
      // ),
    ],
  ),
  const ConversationModel(
    id: 'conv-4',
    customerName: 'Youssef Samir',
    customerHandle: '@youssef',
    serviceTitle: 'Laptop Repair & Setup',
    serviceSummary: 'Diagnostics, cleanup, and fresh software installation.',
    serviceCategory: AdCategories.electronics,
    serviceCity: AdCity.cairo,
    servicePrice: 500,
    status: ConversationStatus.active,
    unreadCount: 0,
    isOnline: false,
    messages: [
      // ChatMessage(
      //   id: 'msg-7',
      //   text: 'Thanks again. The machine is running perfectly now.',
      //   sentAt: DateTime.now().subtract(const Duration(days: 5)),
      //   isFromCurrentUser: false,
      //   deliveryStatus: MessageDeliveryStatus.read,
      // ),
    ],
  ),
];
