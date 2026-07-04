import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/shared_skills.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/locale_cubit.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_body.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_error_state.dart';
import 'package:skillbridge/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool get _isOtherUserProfile {
    if (widget.userId == null) return false;
    final currentUserId = getIt<AuthService>().currentUser?.uid;
    return widget.userId != currentUserId;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ProfileCubit>().loadProfile(userId: widget.userId).then((_) {
      if (mounted) {
        context.read<ProfileCubit>().loadCurrentUserPosts(
          userId: widget.userId,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: ProfileAppBar(
        isOtherUserProfile: _isOtherUserProfile,
        onBack: () => context.popPage(),
        onContactDevelopers: _contactDevelopers,
        onShowLanguageDialog: _showLanguageDialog,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            AppSnackBar.error(context, state.errorMessage);
          }
          if (state is ProfileError) {
            AppSnackBar.error(context, state.message);
          }
        },
        // ── First BlocBuilder: profile header/stats/skills ──
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (prev, curr) =>
              curr is ProfileInitial ||
              curr is ProfileLoading ||
              curr is ProfileSuccess ||
              curr is ProfileFailure,
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state is ProfileFailure) {
              return ProfileErrorState(
                onRetry: () => context
                    .read<ProfileCubit>()
                    .loadProfile(userId: widget.userId)
                    .then((_) {
                      if (mounted) {
                        context.read<ProfileCubit>().loadCurrentUserPosts(
                          userId: widget.userId,
                        );
                      }
                    }),
              );
            }

            if (state is ProfileSuccess) {
              return ProfileBody(
                state: state,
                tabController: _tabController,
                userId: widget.userId,
                onAddSkill: () =>
                    _showSkillPicker(profileCubit, state.userProfile),
                onRemoveSkill: (skill) =>
                    _removeSkill(profileCubit, state.userProfile, skill),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _showSkillPicker(
    ProfileCubit profileCubit,
    UserProfileModel profile,
  ) async {
    final selectedSkills = <String>{...profile.skills};
    final searchController = TextEditingController();
    var query = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                final filtered = SharedSkills.all.where((skill) {
                  return skill.toLowerCase().contains(query.toLowerCase());
                }).toList();

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 20.h,
                    bottom:
                        MediaQuery.of(sheetContext).viewInsets.bottom + 20.h,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Skill',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search skills',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setSheetState(() => query = value);
                          },
                        ),
                        SizedBox(height: 16.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: filtered.map((skill) {
                            final isSelected = selectedSkills.contains(skill);
                            return FilterChip(
                              label: Text(skill),
                              selected: isSelected,
                              onSelected: (selected) {
                                setSheetState(() {
                                  if (selected) {
                                    selectedSkills.add(skill);
                                  } else {
                                    selectedSkills.remove(skill);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.h),
                        PrimaryButton(
                          label: 'Save Skills',
                          onTap: () async {
                            final updated = profile.copyWith(
                              skills: selectedSkills.toList()..sort(),
                            );
                            await profileCubit.updateProfile(updated);
                            if (sheetContext.mounted) {
                              Navigator.of(sheetContext).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    searchController.dispose();
  }

  Future<void> _removeSkill(
    ProfileCubit profileCubit,
    UserProfileModel profile,
    String skill,
  ) async {
    final updatedSkills = profile.skills
        .where((item) => item != skill)
        .toList();
    await profileCubit.updateProfile(profile.copyWith(skills: updatedSkills));
  }
}

Future<void> _contactDevelopers() async {
  final uri = Uri.parse(
    'mailto:support@skillbridge.app?subject=SkillBridge%20Support',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> _showLanguageDialog(BuildContext context) async {
  final localeCubit = context.read<LocaleCubit>();
  final currentLocale = Localizations.localeOf(context).languageCode;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(S.of(dialogContext).language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'en',
              groupValue: currentLocale,
              title: Text(S.of(dialogContext).english),
              onChanged: (value) async {
                if (value != null) {
                  await localeCubit.setLocale(const Locale('en'));
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                }
              },
            ),
            RadioListTile<String>(
              value: 'ar',
              groupValue: currentLocale,
              title: Text(S.of(dialogContext).arabic),
              onChanged: (value) async {
                if (value != null) {
                  await localeCubit.setLocale(const Locale('ar'));
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
