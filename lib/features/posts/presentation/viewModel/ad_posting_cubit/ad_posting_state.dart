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
      SkillTag(label: 'mobile'),
      SkillTag(label: 'web'),
      SkillTag(label: 'cyberSecurity'),
      SkillTag(label: 'gameDevelopment'),
      SkillTag(label: 'devOps'),
      SkillTag(label: 'ai'),
      SkillTag(label: 'dataScience'),
      SkillTag(label: 'uiUxDesign'),
      SkillTag(label: 'blockchain'),
      SkillTag(label: 'cloudComputing'),
      SkillTag(label: 'networking'),
      SkillTag(label: 'seoMarketing'),
      SkillTag(label: 'contentWriting'),
      SkillTag(label: 'digitalMarketing'),
      SkillTag(label: 'graphicDesign'),
      SkillTag(label: 'videoEditing'),
      SkillTag(label: 'projectManagement'),
      SkillTag(label: 'accounting'),
      SkillTag(label: 'languages'),
      SkillTag(label: 'teaching'),
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
