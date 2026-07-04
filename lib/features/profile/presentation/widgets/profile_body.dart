import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_posts_error_state.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_posts_list.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_skills_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_stats_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/sticky_tab_bar_delegate.dart';

class ProfileBody extends StatelessWidget {
  final ProfileSuccess state;
  final TabController tabController;
  final String? userId;
  final VoidCallback? onAddSkill;
  final void Function(String skill)? onRemoveSkill;

  const ProfileBody({
    super.key,
    required this.state,
    required this.tabController,
    required this.userId,
    required this.onAddSkill,
    required this.onRemoveSkill,
  });

  @override
  Widget build(BuildContext context) {
    if (tabController.index != state.selectedTabIndex) {
      tabController.animateTo(state.selectedTabIndex);
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
                    onAddSkill: state.isOtherUserProfile ? null : onAddSkill,
                    onRemoveSkill: state.isOtherUserProfile
                        ? null
                        : onRemoveSkill,
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
          delegate: StickyTabBarDelegate(
            TabBar(
              controller: tabController,
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

      // ── Posts tab content ──
      body: TabBarView(
        controller: tabController,
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (prev, curr) =>
                curr is ProfilePostsLoading ||
                curr is ProfilePostsLoaded ||
                curr is ProfileError,
            builder: (context, blocState) {
              if (blocState is ProfilePostsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (blocState is ProfileError) {
                return ProfilePostsErrorState(
                  onRetry: () => context
                      .read<ProfileCubit>()
                      .loadCurrentUserPosts(userId: userId),
                );
              }

              if (blocState is ProfilePostsLoaded) {
                return ProfilePostsList(posts: blocState.posts);
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
}
