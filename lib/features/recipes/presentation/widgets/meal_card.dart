import 'package:flutter/material.dart';
import '../../domain/entities/meal.dart';
import '../../../../core/widgets/network_image_fallback.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;
  const MealCard({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(url: meal.thumbnail),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${meal.id.length}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Text(
                meal.name,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}