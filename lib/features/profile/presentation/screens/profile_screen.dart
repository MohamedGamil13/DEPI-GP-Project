import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:skillbridge/features/profile/presentation/widgets/post_card_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_skills_widget.dart';
import 'package:skillbridge/features/profile/presentation/widgets/profile_stats_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load profile first, then posts
    context.read<ProfileCubit>().loadProfile().then((_) {
      if (mounted) context.read<ProfileCubit>().loadCurrentUserPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              return _buildBody(state);
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
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.settings_outlined,
            size: 18.sp,
            color: AppColors.textDark,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => AppSnackBar.info(context, 'Share link copied!'),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(
                Icons.share_outlined,
                size: 18.sp,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Body
  // ─────────────────────────────────────────────

  Widget _buildBody(ProfileSuccess state) {
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
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ProfileSkillsWidget(
                    skills: state.userProfile.skills ?? [],
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
              tabs: const [
                Tab(text: 'My Posts'),
                Tab(text: 'Activity'),
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
              'No activity yet.',
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

  // ─────────────────────────────────────────────
  // Posts List
  // ─────────────────────────────────────────────

  Widget _buildPostsList(List<AdModel> posts) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          'No posts yet.',
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
          onTap: () =>
              AppSnackBar.info(context, 'Opening: ${posts[index].title}'),
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
            'Failed to load profile.',
            style: TextStyle(fontSize: 15.sp, color: AppColors.secondaryColor),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().loadProfile().then((
              _,
            ) {
              if (mounted) context.read<ProfileCubit>().loadCurrentUserPosts();
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: Text(
              'Retry',
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
            'Failed to load posts.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryColor),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () =>
                context.read<ProfileCubit>().loadCurrentUserPosts(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              'Retry',
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
