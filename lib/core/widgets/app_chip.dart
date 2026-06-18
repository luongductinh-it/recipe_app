import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;

  const AppChip({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
  });

  factory AppChip.category(String label) {
    return AppChip(
      label: label,
      color: AppColors.chipCategory,
      backgroundColor: AppColors.chipCategoryBg,
    );
  }

  factory AppChip.area(String label) {
    return AppChip(
      label: label,
      color: AppColors.chipArea,
      backgroundColor: AppColors.chipAreaBg,
    );
  }

  factory AppChip.tag(String label) {
    return AppChip(
      label: label,
      color: AppColors.chipTag,
      backgroundColor: AppColors.chipTagBg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallPadding + 4,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
