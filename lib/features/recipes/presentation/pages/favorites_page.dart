import 'package:flutter/material.dart';
import 'package:recipe_app/core/di/locator.dart';
import 'package:recipe_app/features/recipes/data/services/favorite_service.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/meal_grid.dart';
import '../../../../core/constants/app_strings.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  List<Meal> _favorites = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final favorites = await sl<FavoriteService>().getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favorites;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              AppStrings.favoritesTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: !_loaded
                ? const Center(child: CircularProgressIndicator())
                : _favorites.isEmpty
                    ? const EmptyState(
                        icon: Icons.bookmark_border,
                        message: AppStrings.emptyFavorites,
                      )
                    : MealGridView(meals: _favorites),
          ),
        ],
      ),
    );
  }
}
