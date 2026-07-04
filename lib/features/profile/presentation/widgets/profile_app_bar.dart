import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/generated/l10n.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isOtherUserProfile;
  final VoidCallback onBack;
  final Future<void> Function() onContactDevelopers;
  final Future<void> Function(BuildContext context) onShowLanguageDialog;

  const ProfileAppBar({
    super.key,
    required this.isOtherUserProfile,
    required this.onBack,
    required this.onContactDevelopers,
    required this.onShowLanguageDialog,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: isOtherUserProfile
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: onBack,
            )
          : null,
      title: Text(
        isOtherUserProfile ? S.of(context).profile : S.of(context).profile,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      actions: [
        if (!isOtherUserProfile)
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textDark,
            ),
            onSelected: (value) async {
              if (value == 'contact') {
                await onContactDevelopers();
              }
              if (value == 'language') {
                await onShowLanguageDialog(context);
              }
              if (value == 'signout') {
                await context.read<ProfileCubit>().signOut();

                if (context.mounted) {
                  context.gosignIn();

                  AppSnackBar.success(
                    context,
                    AppStrings.signedOutSuccessfully(context),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'language',
                child: Text(S.of(context).language),
              ),
              PopupMenuItem(
                value: 'contact',
                child: Text(S.of(context).contactDevelopers),
              ),
              PopupMenuItem(
                value: 'signout',
                child: Text(S.of(context).signOut),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
