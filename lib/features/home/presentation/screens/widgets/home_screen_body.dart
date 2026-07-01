import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/widgets/no_posts_widget.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/ad_list_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_header.dart';

class HomeScreenBody extends StatelessWidget {
  final bool showCategories;

  const HomeScreenBody({super.key, this.showCategories = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().refreshPosts(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              HomeHeader(
                searchQuery: state is HomeSuccess ? state.searchQuery : '',
                onSearchChanged: context.read<HomeCubit>().searchPosts,
              ),
              if (showCategories) const CategoriesSection(),
              _buildPostsSliver(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsSliver(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is HomeError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<HomeCubit>().refreshPosts(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is HomeSuccess) {
      return state.posts.isEmpty
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: NoPostsWidget(),
            )
          : AdListSection(
              ads: state.posts,
              onFavoriteToggle: (postId) =>
                  context.read<HomeCubit>().toggleFavorite(postId),
            );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: ElevatedButton(
          onPressed: () => context.read<HomeCubit>().getPosts(),
          child: const Text('Load Posts'),
        ),
      ),
    );
  }
}
