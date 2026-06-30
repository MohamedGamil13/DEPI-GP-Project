import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/ad_list_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_header.dart';
import 'package:skillbridge/generated/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final List<AdModel> favoritePosts = state is HomeSuccess
            ? state.posts.where((post) => post.isFavorite).toList()
            : const [];

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            HomeHeader(
              searchQuery: state is HomeSuccess ? state.searchQuery : '',
              onSearchChanged: context.read<HomeCubit>().searchPosts,
            ),
            const CategoriesSection(),
            if (state is HomeLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is HomeError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(state.message)),
              )
            else if (favoritePosts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(S.of(context).noFavoritesYet)),
              )
            else
              AdListSection(
                ads: favoritePosts,
                onFavoriteToggle: (postId) =>
                    context.read<HomeCubit>().toggleFavorite(postId),
              ),
          ],
        );
      },
    );
  }
}
