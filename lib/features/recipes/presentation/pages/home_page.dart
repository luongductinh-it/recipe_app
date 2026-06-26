import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/constants/app_strings.dart';
import 'package:recipe_app/features/recipes/domain/entities/user_meal.dart';
import '../bloc/meal_list_bloc/meal_list_bloc.dart';
import '../bloc/meal_list_bloc/meal_list_event.dart';
import '../bloc/meal_list_bloc/meal_list_state.dart';
import '../bloc/custom_meal_bloc/custom_meal_bloc.dart';
import '../bloc/custom_meal_bloc/custom_meal_event.dart';
import '../bloc/custom_meal_bloc/custom_meal_state.dart';
import '../widgets/search_bar.dart';
import '../../../../core/widgets/category_chips.dart';
import '../../../../core/widgets/meal_grid.dart';

const List<String> _categories = [
  'Seafood',
  'Dessert',
  'Chicken',
  'Beef',
  'Pasta',
  'Vegetarian',
  'Breakfast',
];

class HomePage extends StatefulWidget {
  final VoidCallback? onSearchTap;
  const HomePage({super.key, this.onSearchTap});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Seafood';

  @override
  void initState() {
    super.initState();
    context.read<MealListBloc>().add(LoadMealsByCategory(_selectedCategory));
    context.read<CustomMealBloc>().add(LoadCustomMeals());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SearchBarWidget(
              onTap: widget.onSearchTap,
            ),
          ),
          BlocBuilder<CustomMealBloc, CustomMealState>(
            builder: (context, state) {
              if (state is CustomMealLoaded && state.meals.isNotEmpty) {
                return _buildMyRecipesSection(state.meals);
              }
              return const SizedBox.shrink();
            },
          ),
          CategoryChips(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) {
              setState(() => _selectedCategory = cat);
              context
                  .read<MealListBloc>()
                  .add(LoadMealsByCategory(cat));
            },
          ),
          Expanded(
            child: BlocBuilder<MealListBloc, MealListState>(
              builder: (context, state) {
                if (state is MealListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MealListLoaded) {
                  final meals = state.meals;
                  if (meals.isEmpty) {
                    return const Center(child: Text('No meals found'));
                  }
                  return MealGridView(meals: meals);
                } else if (state is MealListError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRecipesSection(List<UserMeal> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            AppStrings.myRecipes,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return SizedBox(
                width: 120,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: meal.thumbnail.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: meal.thumbnail,
                                fit: BoxFit.cover,
                                memCacheWidth: 240,
                                placeholder: (_, __) => const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ),
                                errorWidget: (_, __, ___) => const Center(
                                  child: Icon(Icons.restaurant, size: 32),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.restaurant, size: 32),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
