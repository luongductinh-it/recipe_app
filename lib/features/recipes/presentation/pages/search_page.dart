import 'package:flutter/material.dart';
import 'package:recipe_app/core/di/locator.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import 'package:recipe_app/features/recipes/domain/usecases/search_meals.dart';
import '../widgets/search_bar.dart';
import '../../../../core/widgets/meal_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Meal> _results = [];
  bool _isLoading = false;

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final useCase = sl<SearchMeals>();
      final meals = await useCase(query);
      setState(() => _results = meals);
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _controller,
              autoFocus: true,
              onChanged: _searchMeals,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(
                        child: Text('Search for a meal'),
                      )
                    : MealGridView(meals: _results),
          ),
        ],
      ),
    );
  }
}
