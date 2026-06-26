import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  const SearchBarWidget({
    super.key,
    this.controller,
    this.autoFocus = false,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (onTap != null && controller == null && !autoFocus) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 12),
              Text(AppStrings.searchHint,
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
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
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, size: 20),
                onPressed: () {
                  controller!.clear();
                  onChanged?.call('');
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: (v) {
        onChanged?.call(v);
      },
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
    );
  }
}