import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/features/posts/data/models/skill_tag.dart';
import 'package:skillbridge/features/posts/presentation/widgets/skill_chip.dart';

/// Wrapping row of skill chips.
/// Receives the skill list and toggle callback from the screen.
class SkillsSection extends StatelessWidget {
  final List<SkillTag> skills;
  final void Function(int index) onToggle;

  const SkillsSection({
    super.key,
    required this.skills,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: skills.asMap().entries.map((entry) {
        return SkillChip(
          label: entry.value.label,
          isSelected: entry.value.isSelected,
          onTap: () => onToggle(entry.key),
        );
      }).toList(),
    );
  }
}
