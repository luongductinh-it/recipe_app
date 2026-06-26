import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_dimensions.dart';

class ShimmerGrid extends StatelessWidget {
  final int itemCount;
  const ShimmerGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding - 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimensions.gridCrossAxisCount,
        childAspectRatio: AppDimensions.gridChildAspectRatio,
        crossAxisSpacing: AppDimensions.gridSpacing,
        mainAxisSpacing: AppDimensions.gridSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerBlock({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}