import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final StoreService _firestoreService;

  HomeCubit({required StoreService firestoreService})
    : _firestoreService = firestoreService,
      super(HomeInitial());

  List<AdModel> _sourcePosts = [];
  Set<int> _favoriteIds = {};
  String _searchQuery = '';
  AdCategories _selectedCategory = AdCategories.all;
  HomeFeedMode _mode = HomeFeedMode.all;

  static String normalizeSearch(String input) {
    return input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool matchesSearch(AdModel ad, String query) {
    final normalizedQuery = normalizeSearch(query);
    if (normalizedQuery.isEmpty) return true;

    final fields = [
      ad.title,
      ad.serviceName,
      ad.category.label,
      ad.description,
    ];

    return fields.any(
      (field) => normalizeSearch(field).contains(normalizedQuery),
    );
  }

  bool _matchesCurrentFilters(AdModel post) {
    if (_selectedCategory != AdCategories.all &&
        post.category != _selectedCategory) {
      return false;
    }

    if (_searchQuery.isNotEmpty && !matchesSearch(post, _searchQuery)) {
      return false;
    }

    return true;
  }

  List<AdModel> _applyFilters(List<AdModel> source) {
    var filtered = source;

    if (_selectedCategory != AdCategories.all) {
      filtered = filtered
          .where((post) => post.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((post) => matchesSearch(post, _searchQuery))
          .toList();
    }

    return filtered
        .map(
          (post) => post.copyWith(isFavorite: _favoriteIds.contains(post.adID)),
        )
        .toList();
  }

  void _emitFiltered({bool loading = false}) {
    if (loading) {
      emit(HomeLoading());
    }

    final filtered = _applyFilters(_sourcePosts);
    emit(
      HomeSuccess(
        allPosts: _sourcePosts,
        posts: filtered,
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        favoriteIds: _favoriteIds,
        mode: _mode,
      ),
    );
  }

  Future<void> getPosts({HomeFeedMode mode = HomeFeedMode.all}) async {
    _mode = mode;
    emit(HomeLoading());
    try {
      final favoritesResult = await _firestoreService.getFavoritePostIds();
      if (favoritesResult case Success<Set<int>>(:final data)) {
        _favoriteIds = data;
      }

      final result = switch (mode) {
        HomeFeedMode.all => await _firestoreService.getAllPosts(),
        HomeFeedMode.favorites => await _firestoreService.getFavoritePosts(),
      };

      switch (result) {
        case Success<List<AdModel>>(:final data):
          _sourcePosts = data
              .map(
                (post) =>
                    post.copyWith(isFavorite: _favoriteIds.contains(post.adID)),
              )
              .toList();
          _emitFiltered();
        case Failure<List<AdModel>>(:final exception):
          emit(HomeError(exception.message));
      }
    } on FirebaseException catch (e) {
      emit(HomeError('Something went wrong : ${e.toString()}'));
    } catch (e) {
      emit(HomeError('Something went wrong : ${e.toString()}'));
    }
  }

  Future<void> refreshPosts() => getPosts(mode: _mode);

  Future<void> getFilteredPosts(AdCategories category) async {
    _selectedCategory = category;
    _emitFiltered();
  }

  void searchPosts(String query) {
    _searchQuery = normalizeSearch(query);
    _emitFiltered();
  }

  Future<void> toggleFavorite(int postId) async {
    final current = state;
    if (current is! HomeSuccess) return;

    final isCurrentlyFavorite = _favoriteIds.contains(postId);
    final updatedFavorites = Set<int>.from(_favoriteIds);

    if (isCurrentlyFavorite) {
      updatedFavorites.remove(postId);
    } else {
      updatedFavorites.add(postId);
    }

    _favoriteIds = updatedFavorites;

    if (_mode == HomeFeedMode.favorites && isCurrentlyFavorite) {
      _sourcePosts = _sourcePosts.where((post) => post.adID != postId).toList();
    } else {
      _sourcePosts = _sourcePosts
          .map(
            (post) => post.adID == postId
                ? post.copyWith(isFavorite: !isCurrentlyFavorite)
                : post.copyWith(isFavorite: _favoriteIds.contains(post.adID)),
          )
          .toList();
    }

    _emitFiltered();

    final result = isCurrentlyFavorite
        ? await _firestoreService.removeFavorite(postId)
        : await _firestoreService.addFavorite(postId);

    if (result case Failure(:final exception)) {
      if (isCurrentlyFavorite) {
        _favoriteIds.add(postId);
      } else {
        _favoriteIds.remove(postId);
      }
      _emitFiltered();
    }
  }

  void syncFavoriteState(int postId, bool isFavorite) {
    final updatedFavorites = Set<int>.from(_favoriteIds);
    if (isFavorite) {
      updatedFavorites.add(postId);
    } else {
      updatedFavorites.remove(postId);
    }

    _favoriteIds = updatedFavorites;
    _sourcePosts = _sourcePosts
        .map(
          (post) => post.adID == postId
              ? post.copyWith(isFavorite: isFavorite)
              : post.copyWith(isFavorite: _favoriteIds.contains(post.adID)),
        )
        .toList();

    if (state is HomeSuccess) {
      _emitFiltered();
    }
  }

  List<AdModel> visibleFavorites() {
    return _sourcePosts
        .where((post) => _favoriteIds.contains(post.adID))
        .where(_matchesCurrentFilters)
        .map((post) => post.copyWith(isFavorite: true))
        .toList();
  }
}
