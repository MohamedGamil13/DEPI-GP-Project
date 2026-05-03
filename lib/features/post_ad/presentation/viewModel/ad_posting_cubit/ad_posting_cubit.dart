import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/post_ad/data/models/skill_tag.dart';

import '../../../data/repos/post_ad_repo.dart';

part 'ad_posting_state.dart';

class AdPostingCubit extends Cubit<AdPostingState> {
  final PostAdRepo _postAdRepo;
  static const int _maxImages = 3;

  AdPostingCubit(this._postAdRepo) : super(const AdPostingInitial());

  List<File> get _images => state.images;
  String? get _selectedCategory => state.selectedCategory;
  List<SkillTag> get _skills => state.skills;

  void _emitUpdated({
    List<File>? images,
    String? selectedCategory,
    List<SkillTag>? skills,
  }) {
    emit(
      AdPostingUpdated(
        images: images ?? _images,
        selectedCategory: selectedCategory ?? _selectedCategory,
        skills: skills ?? _skills,
      ),
    );
  }

  void addImages(List<File> files) {
    final remaining = _maxImages - _images.length;
    if (remaining <= 0) return;
    _emitUpdated(images: [..._images, ...files.take(remaining)]);
  }

  void removeImage(int index) {
    final updated = List<File>.from(_images)..removeAt(index);
    _emitUpdated(images: updated);
  }

  void selectCategory(String? category) {
    _emitUpdated(selectedCategory: category);
  }

  void toggleSkill(int index) {
    final updated = List<SkillTag>.from(_skills)
      ..[index] = _skills[index].copyWith(
        isSelected: !_skills[index].isSelected,
      );
    _emitUpdated(skills: updated);
  }

  Future<void> publishNewAd({required AdModel adModel}) async {
    // ✅ احفظ القيم قبل ما تغير الـ state
    final images = _images;
    final selectedCategory = _selectedCategory;
    final skills = _skills;

    emit(
      AdPostingLoading(
        images: images,
        selectedCategory: selectedCategory,
        skills: skills,
      ),
    );

    final result = await _postAdRepo.publishAd(adModel, images);

    switch (result) {
      case Success(data: _):
        emit(const AdPostingSuccess());
      case Failure(exception: var e):
        emit(
          AdPostingError(
            e.message,
            images: images,
            selectedCategory: selectedCategory,
            skills: skills,
          ),
        );
    }
  }
}
