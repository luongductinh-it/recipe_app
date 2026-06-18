import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  const SearchBarWidget({
    super.key,
    this.controller,
    this.autoFocus = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null && controller == null && !autoFocus) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppDimensions.searchBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: AppColors.greyMedium),
              SizedBox(width: 8),
              Text(AppStrings.searchHint,
                  style: TextStyle(color: AppColors.greyMedium)),
            ],
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        prefixIcon: const Icon(Icons.search, color: AppColors.greyMedium),
        filled: true,
        fillColor: AppColors.greyLight,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.cardBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
