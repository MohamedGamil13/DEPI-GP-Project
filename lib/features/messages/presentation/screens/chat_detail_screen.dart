// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:skillbridge/core/theme/app_colors.dart';
// import 'package:skillbridge/core/theme/app_styles.dart';
// import 'package:skillbridge/features/messages/data/models/chat_message.dart';
// import 'package:skillbridge/features/messages/data/models/service_conversation.dart';
// import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';

// class ChatDetailScreen extends StatefulWidget {
//   const ChatDetailScreen({super.key});

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MessagesCubit, MessagesState>(
//       builder: (context, state) {
//         if (state is! MessagesLoaded || state.activeConversation == null) {
//           return const Scaffold(
//             body: Center(child: Text('Conversation unavailable')),
//           );
//         }

//         final conversation = state.activeConversation!;

//         return Scaffold(
//           backgroundColor: AppColors.backgroundColor,
//           appBar: AppBar(
//             backgroundColor: AppColors.backgroundColor,
//             foregroundColor: AppColors.textDark,
//             elevation: 0,
//             titleSpacing: 0,
//             title: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: AppColors.primaryLight,
//                   child: Text(
//                     conversation.customerName
//                         .split(' ')
//                         .where((part) => part.isNotEmpty)
//                         .take(2)
//                         .map((part) => part[0])
//                         .join(),
//                     style: AppStyles.font14w600.copyWith(
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         conversation.customerName,
//                         style: AppStyles.font14w600.copyWith(fontSize: 16),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         conversation.isOnline
//                             ? 'Online now'
//                             : conversation.customerHandle,
//                         style: AppStyles.font13w500.copyWith(
//                           color: AppColors.textLight,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
//                 child: _ServiceContextCard(conversation: conversation),
//               ),
//               Expanded(
//                 child: ListView.separated(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
//                   itemBuilder: (context, index) {
//                     final message = conversation.messages[index];
//                     return _MessageBubble(message: message);
//                   },
//                   separatorBuilder: (_, index) => const SizedBox(height: 10),
//                   itemCount: conversation.messages.length,
//                 ),
//               ),
//               SafeArea(
//                 top: false,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _controller,
//                           minLines: 1,
//                           maxLines: 4,
//                           decoration: InputDecoration(
//                             hintText: 'Reply about this service...',
//                             filled: true,
//                             fillColor: AppColors.surfaceColor,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(18),
//                               borderSide: const BorderSide(
//                                 color: AppColors.border,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(18),
//                               borderSide: const BorderSide(
//                                 color: AppColors.border,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(18),
//                               borderSide: const BorderSide(
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Material(
//                         color: AppColors.primaryColor,
//                         shape: const CircleBorder(),
//                         child: InkWell(
//                           customBorder: const CircleBorder(),
//                           onTap: state.isSendingMessage
//                               ? null
//                               : () async {
//                                   final text = _controller.text;
//                                   _controller.clear();
//                                   await context
//                                       .read<MessagesCubit>()
//                                       .sendMessage(text);
//                                 },
//                           child: SizedBox(
//                             width: 52,
//                             height: 52,
//                             child: state.isSendingMessage
//                                 ? const Padding(
//                                     padding: EdgeInsets.all(14),
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: AppColors.white,
//                                     ),
//                                   )
//                                 : const Icon(
//                                     Icons.send_rounded,
//                                     color: AppColors.white,
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _ServiceContextCard extends StatelessWidget {
//   final ServiceConversation conversation;

//   const _ServiceContextCard({required this.conversation});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   conversation.serviceTitle,
//                   style: AppStyles.font17Bold.copyWith(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               _StatusBadge(status: conversation.status),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             conversation.serviceSummary,
//             style: AppStyles.font14Regular.copyWith(
//               color: AppColors.textMedium,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               _InfoBadge(
//                 icon: conversation.serviceCategory.icon,
//                 label: conversation.serviceCategory.label,
//               ),
//               _InfoBadge(
//                 icon: Icons.location_on_outlined,
//                 label: conversation.serviceCity.label,
//               ),
//               _InfoBadge(
//                 icon: Icons.payments_outlined,
//                 label: 'EGP ${conversation.servicePrice.toStringAsFixed(0)}',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoBadge extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _InfoBadge({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: AppColors.textMedium),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: AppStyles.font13w500.copyWith(color: AppColors.textMedium),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatusBadge extends StatelessWidget {
//   final ConversationStatus status;

//   const _StatusBadge({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     final background = switch (status) {
//       ConversationStatus.newLead => const Color(0xFFE6F4EA),
//       ConversationStatus.active => AppColors.primaryLight,
//       ConversationStatus.waiting => const Color(0xFFFFF3D6),
//       ConversationStatus.archived => const Color(0xFFF3F4F6),
//     };

//     final foreground = switch (status) {
//       ConversationStatus.newLead => const Color(0xFF15803D),
//       ConversationStatus.active => AppColors.primaryColor,
//       ConversationStatus.waiting => const Color(0xFFB7791F),
//       ConversationStatus.archived => AppColors.textMedium,
//     };

//     final label = switch (status) {
//       ConversationStatus.newLead => 'New Lead',
//       ConversationStatus.active => 'Active',
//       ConversationStatus.waiting => 'Waiting',
//       ConversationStatus.archived => 'Archived',
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: background,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         label,
//         style: AppStyles.font13w500.copyWith(color: foreground),
//       ),
//     );
//   }
// }

// class _MessageBubble extends StatelessWidget {
//   final ChatMessage message;

//   const _MessageBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final isCurrentUser = message.isFromCurrentUser;

//     return Align(
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 280),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
//           decoration: BoxDecoration(
//             color: isCurrentUser
//                 ? AppColors.primaryColor
//                 : AppColors.surfaceColor,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(18),
//               topRight: const Radius.circular(18),
//               bottomLeft: Radius.circular(isCurrentUser ? 18 : 6),
//               bottomRight: Radius.circular(isCurrentUser ? 6 : 18),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.text,
//                 style: AppStyles.font14Regular.copyWith(
//                   color: isCurrentUser ? AppColors.white : AppColors.textDark,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     _messageTime(message.sentAt),
//                     style: AppStyles.font13w500.copyWith(
//                       color: isCurrentUser
//                           ? AppColors.white.withValues(alpha: 0.8)
//                           : AppColors.textLight,
//                     ),
//                   ),
//                   if (isCurrentUser) ...[
//                     const SizedBox(width: 6),
//                     Icon(
//                       message.deliveryStatus == MessageDeliveryStatus.read
//                           ? Icons.done_all_rounded
//                           : Icons.done_rounded,
//                       size: 14,
//                       color: AppColors.white.withValues(alpha: 0.9),
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String _messageTime(DateTime value) {
//   final hour = value.hour > 12
//       ? value.hour - 12
//       : (value.hour == 0 ? 12 : value.hour);
//   final minute = value.minute.toString().padLeft(2, '0');
//   final suffix = value.hour >= 12 ? 'PM' : 'AM';
//   return '$hour:$minute $suffix';
// }
