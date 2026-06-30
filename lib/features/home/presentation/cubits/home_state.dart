part of 'home_cubit.dart';

enum HomeFeedMode { all, favorites }

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<AdModel> allPosts;
  final List<AdModel> posts;
  final String searchQuery;
  final AdCategories selectedCategory;
  final Set<int> favoriteIds;
  final HomeFeedMode mode;

  HomeSuccess({
    required this.allPosts,
    required this.posts,
    this.searchQuery = '',
    this.selectedCategory = AdCategories.all,
    this.favoriteIds = const {},
    this.mode = HomeFeedMode.all,
  });

  HomeSuccess copyWith({
    List<AdModel>? allPosts,
    List<AdModel>? posts,
    String? searchQuery,
    AdCategories? selectedCategory,
    Set<int>? favoriteIds,
    HomeFeedMode? mode,
  }) {
    return HomeSuccess(
      allPosts: allPosts ?? this.allPosts,
      posts: posts ?? this.posts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      mode: mode ?? this.mode,
    );
  }
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
