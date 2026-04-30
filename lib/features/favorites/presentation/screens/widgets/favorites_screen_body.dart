import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/favorites/presentation/cubits/favorites_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/ad_list_section.dart';

class FavoritesScreenBody extends StatelessWidget {
  const FavoritesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [_buildFavoritesSliver(context, state)],
        );
      },
    );
  }

  Widget _buildFavoritesSliver(BuildContext context, FavoritesState state) {
    if (state is FavoritesLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is FavoritesError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<FavoritesCubit>().loadFavorites(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is FavoritesSuccess) {
      if (state.ads.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text("No favorites yet")),
        );
      }

      return AdListSection(ads: state.ads);
    }

    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: Text("No Data")),
    );
  }
}
