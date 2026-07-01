import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/core/utils/constants/shared_skills.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/locale_cubit.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/features/profile/presentation/widgets/post_card_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_skills_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_stats_widget.dart';
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
      appBar: _buildAppBar(),
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
              return _buildErrorState();
            }

            if (state is ProfileSuccess) {
              return _buildBody(state, profileCubit);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: _isOtherUserProfile
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => context.popPage(),
            )
          : null,
      title: Text(
        _isOtherUserProfile ? S.of(context).profile : S.of(context).profile,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      actions: [
        if (!_isOtherUserProfile)
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textDark,
            ),
            onSelected: (value) async {
              if (value == 'contact') {
                await _contactDevelopers();
              }
              if (value == 'language') {
                await _showLanguageDialog(context);
              }
              if (value == 'signout') {
                await context.read<ProfileCubit>().signOut();

                if (mounted) {
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

  // ─────────────────────────────────────────────
  // Body
  // ─────────────────────────────────────────────

  Widget _buildBody(ProfileSuccess state, ProfileCubit profileCubit) {
    if (_tabController.index != state.selectedTabIndex) {
      _tabController.animateTo(state.selectedTabIndex);
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                ProfileHeaderWidget(profile: state.userProfile),
                SizedBox(height: 24.h),
                ProfileStatsWidget(profile: state.userProfile),
                if (_formatLocation(state.userProfile) != null) ...[
                  SizedBox(height: 14.h),
                  Text(
                    _formatLocation(state.userProfile)!,
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (state.userProfile.bio.trim().isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.userProfile.bio,
                      style: TextStyle(
                        color: AppColors.textMedium,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ProfileSkillsWidget(
                    skills: state.userProfile.skills,
                    onAddSkill: state.isOtherUserProfile
                        ? null
                        : () =>
                              _showSkillPicker(profileCubit, state.userProfile),
                    onRemoveSkill: state.isOtherUserProfile
                        ? null
                        : (skill) => _removeSkill(
                            profileCubit,
                            state.userProfile,
                            skill,
                          ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),

        // ── Sticky Tab Bar ──
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyTabBarDelegate(
            TabBar(
              controller: _tabController,
              onTap: (index) {},
              indicatorColor: AppColors.primaryColor,
              indicatorWeight: 2.5,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.secondaryColor,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
              tabs: [
                Tab(text: AppStrings.tabMyPosts(context)),
                Tab(text: AppStrings.tabActivity(context)),
              ],
            ),
          ),
        ),
      ],

      // ── Second BlocBuilder: posts tab content ──
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (prev, curr) =>
                curr is ProfilePostsLoading ||
                curr is ProfilePostsLoaded ||
                curr is ProfileError,
            builder: (context, state) {
              if (state is ProfilePostsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state is ProfileError) {
                return _buildPostsErrorState();
              }

              if (state is ProfilePostsLoaded) {
                return _buildPostsList(state.posts);
              }

              // Still waiting for posts to load
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            },
          ),

          // Activity tab — wired up when backend is ready
          Center(
            child: Text(
              AppStrings.noActivityYet(context),
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
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

  String? _formatLocation(UserProfileModel profile) {
    final city = profile.city.trim();
    final governorate = profile.governorate.trim();
    final country = profile.country.trim();

    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (governorate.isNotEmpty &&
        governorate.toLowerCase() != city.toLowerCase()) {
      parts.add(governorate);
    }
    if (country.isNotEmpty &&
        country.toLowerCase() != governorate.toLowerCase() &&
        country.toLowerCase() != city.toLowerCase()) {
      parts.add(country);
    }

    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  // ─────────────────────────────────────────────
  // Posts List
  // ─────────────────────────────────────────────

  Widget _buildPostsList(List<AdModel> posts) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noPostsYet(context),
          style: TextStyle(color: AppColors.secondaryColor, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCardWidget(
          post: posts[index],
          onTap: () => context.goAdDetails(posts[index]),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Error States
  // ─────────────────────────────────────────────

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 54.sp, color: AppColors.errorColor),
          SizedBox(height: 12.h),
          Text(
            AppStrings.failedToLoadProfile(context),
            style: TextStyle(fontSize: 15.sp, color: AppColors.secondaryColor),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context
                .read<ProfileCubit>()
                .loadProfile(userId: widget.userId)
                .then((_) {
                  if (mounted) {
                    context.read<ProfileCubit>().loadCurrentUserPosts(
                      userId: widget.userId,
                    );
                  }
                }),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: Text(
              AppStrings.retry(context),
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40.sp, color: AppColors.errorColor),
          SizedBox(height: 12.h),
          Text(
            AppStrings.failedToLoadPosts(context),
            style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryColor),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().loadCurrentUserPosts(
              userId: widget.userId,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              AppStrings.retry(context),
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
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

// ─────────────────────────────────────────────
// Sticky Tab Bar Delegate
// ─────────────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.backgroundColor, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
