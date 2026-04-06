import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class CustomFilterChip<T> extends StatefulWidget {
  const CustomFilterChip({
    super.key,
    required this.label,
    required this.items,
    required this.getLabel,
    this.getIcon,
    this.leadingIcon,
    this.onChanged,
  });

  final String label;
  final List<T> items;

  /// how to display text
  final String Function(T) getLabel;

  /// optional icon per item
  final IconData Function(T)? getIcon;

  /// icon before selected value (like location icon)
  final IconData? leadingIcon;

  final Function(T?)? onChanged;

  @override
  State<CustomFilterChip<T>> createState() => _CustomFilterChipState<T>();
}

class _CustomFilterChipState<T> extends State<CustomFilterChip<T>> {
  T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedItem,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconEnabledColor: AppColors.primaryColor,
          dropdownColor: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),

          /// Hint (before selection)
          hint: Row(
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(
                  widget.leadingIcon,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                widget.label,
                style: AppStyles.font14Regular.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),

          /// Dropdown items
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.getLabel(item),
                    style: AppStyles.font14Regular.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                  if (widget.getIcon != null)
                    Icon(widget.getIcon!(item), color: AppColors.primaryColor),
                ],
              ),
            );
          }).toList(),

          /// On change
          onChanged: (value) {
            setState(() => selectedItem = value);
            widget.onChanged?.call(value);
          },

          /// Selected item UI
          selectedItemBuilder: (context) {
            return widget.items.map((item) {
              return Row(
                children: [
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    widget.getLabel(item),
                    style: AppStyles.font14Regular.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
