import 'package:cached_network_image/cached_network_image.dart';
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
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: 400,
      placeholder: (_, __) => Container(
        color: AppColors.greyLight,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.greyLight,
        child: Icon(
          Icons.broken_image,
          size: fallbackIconSize,
        ),
      ),
    );
  }
}
