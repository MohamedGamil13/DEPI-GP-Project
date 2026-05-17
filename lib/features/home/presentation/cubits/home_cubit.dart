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

  Future<void> getPosts() async {
    emit(HomeLoading());
    try {
      final result = await _firestoreService.getAllPosts();
      switch (result) {
        case Success<List<AdModel>>(:final data):
          emit(HomeSuccess(posts: data));
        case Failure<List<AdModel>>(:final exception):
          emit(HomeError(exception.message));
      }
    } on FirebaseException catch (e) {
      emit(HomeError('Something went wrong : ${e.toString()}'));
    } catch (e) {
      emit(HomeError('Something went wrong : ${e.toString()}'));
    }
  }

  // Fetch Filtered Posts By Category

  Future<void> getFilteredPosts(AdCategories category) async {
    emit(HomeLoading());
    try {
      final result = await _firestoreService.getFilteredPosts(category);
      switch (result) {
        case Success<List<AdModel>>(:final data):
          emit(HomeSuccess(posts: data));
        case Failure<List<AdModel>>(:final exception):
          emit(HomeError(exception.message));
      }
    } catch (e) {
      emit(HomeError('Something went wrong: ${e.toString()}'));
    }
  }

  //  Search Post By Title

  Future<void> searchPost(String title) async {
    emit(HomeLoading());
    try {
      final result = await _firestoreService.searchForPost(title);
      switch (result) {
        case Success<AdModel>(:final data):
          emit(HomeSuccess(posts: [data]));
        case Failure<AdModel>(:final exception):
          emit(HomeError(exception.message));
      }
    } catch (e) {
      emit(HomeError('Something went wrong: ${e.toString()}'));
    }
  }
}
