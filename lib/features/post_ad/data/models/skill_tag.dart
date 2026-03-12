/// Represents a single skill tag in the "Relevant Skills" section.
/// Pure Dart — no Flutter dependencies.
class SkillTag {
  final String label;
  final bool isSelected;

  const SkillTag({
    required this.label,
    this.isSelected = false,
  });

  SkillTag copyWith({bool? isSelected}) => SkillTag(
        label: label,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  String toString() => 'SkillTag(label: $label, isSelected: $isSelected)';
}
