import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import 'package:recipe_app/features/recipes/presentation/widgets/meal_card.dart';
import 'package:recipe_app/features/recipes/presentation/pages/meal_detail_page.dart';
import '../constants/app_dimensions.dart';

class MealGridView extends StatelessWidget {
  final List<Meal> meals;

  const MealGridView({
    super.key,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding - 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimensions.gridCrossAxisCount,
        childAspectRatio: AppDimensions.gridChildAspectRatio,
        crossAxisSpacing: AppDimensions.gridSpacing,
        mainAxisSpacing: AppDimensions.gridSpacing,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return MealCard(
          meal: meal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MealDetailPage(mealId: meal.id),
              ),
            );
          },
        );
      },
    );
  }
}
