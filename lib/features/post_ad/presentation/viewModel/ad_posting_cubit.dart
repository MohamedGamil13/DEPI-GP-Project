import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/post_ad/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostAdRepo repo;

  PostCubit({required this.repo}) : super(const PostState());

  void addImages(List<File> files) {
    emit(state.copyWith(images: [...state.images, ...files]));
  }

  void removeImage(File file) {
    emit(state.copyWith(images: state.images..remove(file)));
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void toggleSkill(String label) {
    final updatedSkills = state.skills.map((s) {
      if (s.label == label) return s.copyWith(isSelected: !s.isSelected);
      return s;
    }).toList();
    emit(state.copyWith(skills: updatedSkills));
  }

  Future<void> publishNewAd({required AdModel adModel}) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await repo.publishAd(adModel, state.images);

      switch (result) {
        case Success():
          emit(state.copyWith(isLoading: false));
          break;
        case Failure(exception: final e):
          emit(state.copyWith(isLoading: false, error: e.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
