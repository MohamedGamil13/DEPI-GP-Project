import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    final currentUser = getIt<AuthService>().currentUser;
    if (currentUser != null) {
      context.read<MessagesCubit>().loadInbox(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textDark,
        title: Text(AppStrings.messages(context)),
      ),
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          if (state is MessagesLoading || state is MessagesInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is MessagesError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                final currentUser = getIt<AuthService>().currentUser;
                if (currentUser != null) {
                  context.read<MessagesCubit>().loadInbox(currentUser.uid);
                }
              },
            );
          }

          final loadedState = state as MessagesLoaded;
          final conversations = loadedState.visibleConversations;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: _InboxSearchField(
                  initialValue: loadedState.searchQuery,
                  onChanged: context.read<MessagesCubit>().updateSearchQuery,
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: MessageFilter.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = MessageFilter.values[index];
                    return _FilterChip(
                      label: _filterLabel(context, filter),
                      isSelected: loadedState.selectedFilter == filter,
                      onTap: () =>
                          context.read<MessagesCubit>().selectFilter(filter),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: conversations.isEmpty
                    ? const _EmptyInbox()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: conversations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final conversation = conversations[index];
                          return _ConversationCard(
                            conversation: conversation,
                            onTap: () async {
                              await context
                                  .read<MessagesCubit>()
                                  .openConversation(
                                    conversationId: conversation.id,
                                    currentUserId:
                                        getIt<AuthService>().currentUser!.uid,
                                  );
                              if (context.mounted) {
                                context.goChatDetail(conversation);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Search Field ─────────────────────────────────────────────────────────────

class _InboxSearchField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _InboxSearchField({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_InboxSearchField> createState() => _InboxSearchFieldState();
}

class _InboxSearchFieldState extends State<_InboxSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: AppStrings.searchConversations(context),
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: AppColors.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

// ── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.font13w500.copyWith(
            color: isSelected ? AppColors.white : AppColors.textMedium,
          ),
        ),
      ),
    );
  }
}

// ── Conversation Card ─────────────────────────────────────────────────────────

class _ConversationCard extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const _ConversationCard({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final latestMessage = conversation.latestMessage;

    return Material(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ConversationAvatar(
                name: conversation.customerName,
                isOnline: conversation.isOnline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.font17Bold.copyWith(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(context, latestMessage?.sentAt),
                          style: AppStyles.font13w500.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      latestMessage?.text ?? AppStrings.noMessagesYet(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.font14Regular.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          icon: Icons.work_outline_rounded,
                          label: conversation.serviceTitle,
                          color: AppColors.primaryLight,
                          textColor: AppColors.primaryColor,
                        ),
                        _MetaChip(
                          icon: Icons.flag_outlined,
                          label: _statusLabel(context, conversation.status),
                          color: _statusBackground(conversation.status),
                          textColor: _statusForeground(conversation.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    '${conversation.unreadCount}',
                    style: AppStyles.font13w500.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationAvatar extends StatelessWidget {
  final String name;
  final bool isOnline;

  const _ConversationAvatar({required this.name, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            initials,
            style: AppStyles.font14w600.copyWith(color: AppColors.primaryColor),
          ),
        ),
        if (isOnline)
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
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.font13w500.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.font14Regular.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppStrings.tryAgain(context)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty Inbox ───────────────────────────────────────────────────────────────

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
                size: 34,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppStrings.noConversations(context),
              style: AppStyles.font17Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyInboxDescription(context),
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

// ── Helpers ───────────────────────────────────────────────────────────────────

String _filterLabel(BuildContext context, MessageFilter filter) =>
    switch (filter) {
      MessageFilter.all => AppStrings.all(context),
      MessageFilter.newLeads => AppStrings.newLeads(context),
      MessageFilter.active => AppStrings.active(context),
    };

String _statusLabel(BuildContext context, ConversationStatus status) =>
    switch (status) {
      ConversationStatus.newLead => AppStrings.newLead(context),
      ConversationStatus.active => AppStrings.active(context),
      ConversationStatus.waiting => AppStrings.waiting(context),
      ConversationStatus.closed => AppStrings.closed(context),
    };

Color _statusBackground(ConversationStatus status) => switch (status) {
  ConversationStatus.newLead => const Color(0xFFE6F4EA),
  ConversationStatus.active => const Color(0xFFE8F0FF),
  ConversationStatus.waiting => const Color(0xFFFFF3D6),
  ConversationStatus.closed => const Color(0xFFF3F4F6),
};

Color _statusForeground(ConversationStatus status) => switch (status) {
  ConversationStatus.newLead => const Color(0xFF15803D),
  ConversationStatus.active => AppColors.primaryColor,
  ConversationStatus.waiting => const Color(0xFFB7791F),
  ConversationStatus.closed => AppColors.textMedium,
};

String _formatTimestamp(BuildContext context, DateTime? value) {
  if (value == null) return '';
  final now = DateTime.now();
  final difference = now.difference(value);

  if (difference.inDays == 0) {
    final hour = value.hour > 12
        ? value.hour - 12
        : (value.hour == 0 ? 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
  if (difference.inDays == 1) return AppStrings.yesterdayShort(context);
  if (difference.inDays < 7) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[value.weekday - 1];
  }
  return '${value.day}/${value.month}';
}
