import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/features/messages/data/models/chat_message.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';

/// The current logged-in user's ID — inject via constructor or DI in production.
/// Replace with your auth provider's `currentUser.uid`.
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loadingOlderMessages = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    });
  }

  void _loadOlderMessages() {
    if (_loadingOlderMessages) return;
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels > 40) return;

    _loadingOlderMessages = true;
    context.read<MessagesCubit>().loadOlderMessages().whenComplete(() {
      _loadingOlderMessages = false;
    });
  }

  Future<void> _send() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await context.read<MessagesCubit>().sendMessage(
      text: text,
      senderId: getIt<AuthService>().currentUser!.uid,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesCubit, MessagesState>(
      listenWhen: (previous, current) {
        // Scroll down whenever the message list grows.
        if (previous is MessagesLoaded && current is MessagesLoaded) {
          final prev = previous.activeConversation?.messages.length ?? 0;
          final next = current.activeConversation?.messages.length ?? 0;
          return next > prev;
        }
        return false;
      },
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        if (state is! MessagesLoaded || state.activeConversation == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        final conversation = state.activeConversation!;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _ChatAppBar(conversation: conversation),
          body: Column(
            children: [
              // Service context banner
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: _ServiceContextCard(conversation: conversation),
              ),

              // Message list
              Expanded(
                child: conversation.messages.isEmpty
                    ? const _EmptyChat()
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification &&
                              notification.metrics.pixels <= 40) {
                            _loadOlderMessages();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: conversation.messages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final message = conversation.messages[index];
                            final previousMessage = index > 0
                                ? conversation.messages[index - 1]
                                : null;
                            final showDateDivider =
                                previousMessage == null ||
                                !_isSameDay(
                                  message.sentAt,
                                  previousMessage.sentAt,
                                );

                            return Column(
                              children: [
                                if (showDateDivider)
                                  _DateDivider(date: message.sentAt),
                                _MessageBubble(
                                  message: message,
                                  currentUserId:
                                      getIt<AuthService>().currentUser!.uid,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
              ),

              if (state.isLoadingOlderMessages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    AppStrings.loadingOlderMessages(context),
                    style: AppStyles.font13w500.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),

              // Input bar
              _MessageInputBar(
                controller: _controller,
                isSending: state.isSendingMessage,
                onSend: _send,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ConversationModel conversation;

  const _ChatAppBar({required this.conversation});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final initials = conversation.customerName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0])
        .join();

    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          context.read<MessagesCubit>().closeConversation();
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  initials,
                  style: AppStyles.font14w600.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              if (conversation.isOnline)
                const Positioned(
                  right: -1,
                  bottom: -1,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  conversation.customerName,
                  style: AppStyles.font14w600.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  conversation.isOnline
                      ? AppStrings.onlineNow(context)
                      : conversation.customerHandle,
                  style: AppStyles.font13w500.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<ConversationStatus>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (status) => context.read<MessagesCubit>().updateStatus(
            conversationId: conversation.id,
            status: status,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: ConversationStatus.active,
              child: Text(AppStrings.markAsActive(context)),
            ),
            PopupMenuItem(
              value: ConversationStatus.waiting,
              child: Text(AppStrings.markAsWaiting(context)),
            ),
            PopupMenuItem(
              value: ConversationStatus.closed,
              child: Text(AppStrings.closeConversation(context)),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Service Context Card ─────────────────────────────────────────────────────

class _ServiceContextCard extends StatelessWidget {
  final ConversationModel conversation;

  const _ServiceContextCard({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  conversation.serviceTitle,
                  style: AppStyles.font17Bold.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(width: 10),
              _StatusBadge(status: conversation.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            conversation.serviceSummary,
            style: AppStyles.font14Regular.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoBadge(
                icon: conversation.serviceCategory.icon,
                label: conversation.serviceCategory.label,
              ),
              _InfoBadge(
                icon: Icons.location_on_outlined,
                label: conversation.serviceCity.label,
              ),
              _InfoBadge(
                icon: Icons.payments_outlined,
                label: 'EGP ${conversation.servicePrice.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMedium),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppStyles.font13w500.copyWith(color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ConversationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      ConversationStatus.newLead => (
        const Color(0xFFE6F4EA),
        const Color(0xFF15803D),
        AppStrings.newLead(context),
      ),
      ConversationStatus.active => (
        AppColors.primaryLight,
        AppColors.primaryColor,
        AppStrings.active(context),
      ),
      ConversationStatus.waiting => (
        const Color(0xFFFFF3D6),
        const Color(0xFFB7791F),
        AppStrings.waiting(context),
      ),
      ConversationStatus.closed => (
        const Color(0xFFF3F4F6),
        AppColors.textMedium,
        AppStrings.closed(context),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppStyles.font13w500.copyWith(color: fg)),
    );
  }
}

// ── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;

  const _MessageBubble({required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromCurrentUser(currentUserId);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primaryColor : AppColors.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: AppStyles.font14Regular.copyWith(
                  color: isMe ? AppColors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _messageTime(message.sentAt),
                    style: AppStyles.font13w500.copyWith(
                      fontSize: 11,
                      color: isMe
                          ? AppColors.white.withValues(alpha: 0.75)
                          : AppColors.textLight,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 5),
                    Icon(
                      _deliveryIcon(message.deliveryStatus),
                      size: 14,
                      color:
                          message.deliveryStatus == MessageDeliveryStatus.read
                          ? const Color(0xFF93C5FD)
                          : AppColors.white.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _deliveryIcon(MessageDeliveryStatus status) => switch (status) {
    MessageDeliveryStatus.sent => Icons.done_rounded,
    MessageDeliveryStatus.delivered => Icons.done_all_rounded,
    MessageDeliveryStatus.read => Icons.done_all_rounded,
  };
}

// ── Date Divider ─────────────────────────────────────────────────────────────

class _DateDivider extends StatelessWidget {
  final DateTime date;

  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String label;

    if (_isSameDay(date, now)) {
      label = AppStrings.today(context);
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = AppStrings.yesterday(context);
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: AppStyles.font13w500.copyWith(
                color: AppColors.textLight,
                fontSize: 11,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }
}

// ── Empty Chat ───────────────────────────────────────────────────────────────

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 30,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.startConversation(context),
              style: AppStyles.font17Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.sendMessagePrompt(context),
              textAlign: TextAlign.center,
              style: AppStyles.font14Regular.copyWith(
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Input Bar ────────────────────────────────────────────────────────────────

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _MessageInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: AppStrings.sendMessageHint(context),
                  filled: true,
                  fillColor: AppColors.surfaceColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: AppColors.primaryColor,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: isSending ? null : onSend,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: isSending
                      ? const Padding(
                          padding: EdgeInsets.all(13),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _messageTime(DateTime value) {
  final hour = value.hour > 12
      ? value.hour - 12
      : (value.hour == 0 ? 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}
