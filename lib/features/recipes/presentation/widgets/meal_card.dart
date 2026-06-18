import 'package:flutter/material.dart';
import '../../domain/entities/meal.dart';
import '../../../../core/widgets/network_image_fallback.dart';
import '../../../../core/constants/app_dimensions.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;
  const MealCard({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: NetworkImageWithFallback(url: meal.thumbnail),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.smallPadding),
              child: Text(
                meal.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
