import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? fallbackIconSize;

  const NetworkImageWithFallback({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.fallbackIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.greyLight,
        child: Icon(
          Icons.broken_image,
          size: fallbackIconSize,
        ),
      ),
    );
  }
}
