import 'dart:io';

class PostState {
  final List<File> images;
  final String? selectedCategory;
  final List<SkillItem> skills;
  final bool isLoading;
  final String? error;

  const PostState({
    this.images = const [],
    this.selectedCategory,
    this.skills = const [],
    this.isLoading = false,
    this.error,
  });

  PostState copyWith({
    List<File>? images,
    String? selectedCategory,
    List<SkillItem>? skills,
    bool? isLoading,
    String? error,
  }) {
    return PostState(
      images: images ?? this.images,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      skills: skills ?? this.skills,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SkillItem {
  final String label;
  final bool isSelected;
  const SkillItem({required this.label, this.isSelected = false});

  SkillItem copyWith({bool? isSelected}) {
    return SkillItem(label: label, isSelected: isSelected ?? this.isSelected);
  }
}
