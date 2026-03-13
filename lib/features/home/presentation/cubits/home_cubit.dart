import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  void getPosts() async {
    emit(HomeLoading());
    try {
      // final posts = await Repository.getAllPosts();
      // emit(HomeSuccess(posts: posts));
    } catch (e) {
      emit(HomeError('Something went wrong'));
    }
  }
}
