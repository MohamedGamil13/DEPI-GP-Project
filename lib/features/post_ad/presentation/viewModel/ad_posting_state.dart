// ad_posting_state.dart
part of 'ad_posting_cubit.dart';

@immutable
sealed class AdPostingState {
  final List<File> images;
  final String? selectedCategory;
  final List<SkillTag> skills;

  const AdPostingState({
    this.images = const [],
    this.selectedCategory,
    this.skills = const [
      SkillTag(label: 'React', isSelected: true),
      SkillTag(label: 'Python', isSelected: true),
      SkillTag(label: 'Cleaning'),
      SkillTag(label: 'JavaScript'),
      SkillTag(label: 'Gardening'),
      SkillTag(label: 'Design'),
      SkillTag(label: 'Marketing'),
      SkillTag(label: 'Education'),
    ],
  });
}

final class AdPostingInitial extends AdPostingState {
  const AdPostingInitial() : super();
}

final class AdPostingUpdated extends AdPostingState {
  const AdPostingUpdated({
    required super.images,
    required super.selectedCategory,
    required super.skills,
  });
}

final class AdPostingLoading extends AdPostingState {
  const AdPostingLoading({
    required super.images,
    required super.selectedCategory,
    required super.skills,
  });
}

final class AdPostingSuccess extends AdPostingState {
  const AdPostingSuccess() : super();
}

final class AdPostingError extends AdPostingState {
  final String message;
  const AdPostingError(
    this.message, {
    required super.images,
    required super.selectedCategory,
    required super.skills,
  });
}
