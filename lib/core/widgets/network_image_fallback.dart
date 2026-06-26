import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: 400,
      placeholder: (_, __) => Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image,
          size: fallbackIconSize,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}