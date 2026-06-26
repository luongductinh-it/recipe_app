import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/constants/app_strings.dart';
import 'package:recipe_app/core/widgets/home_banner.dart';
import 'package:recipe_app/core/widgets/shimmer_grid.dart';
import 'package:recipe_app/features/recipes/domain/entities/user_meal.dart';
import '../bloc/meal_list_bloc/meal_list_bloc.dart';
import '../bloc/meal_list_bloc/meal_list_event.dart';
import '../bloc/meal_list_bloc/meal_list_state.dart';
import '../bloc/custom_meal_bloc/custom_meal_bloc.dart';
import '../bloc/custom_meal_bloc/custom_meal_event.dart';
import '../bloc/custom_meal_bloc/custom_meal_state.dart';
import '../widgets/search_bar.dart';
import 'meal_detail_page.dart';
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
    final theme = Theme.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<MealListBloc>().add(
            LoadMealsByCategory(_selectedCategory),
          );
          context.read<CustomMealBloc>().add(LoadCustomMeals());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'What would you like\nto cook today?',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SearchBarWidget(onTap: widget.onSearchTap),
            ),
            BlocBuilder<MealListBloc, MealListState>(
              builder: (context, state) {
                if (state is MealListLoaded && state.meals.isNotEmpty) {
                  return HomeBanner(meals: state.meals.take(5).toList());
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<CustomMealBloc, CustomMealState>(
              builder: (context, state) {
                if (state is CustomMealLoaded && state.meals.isNotEmpty) {
                  return _buildMyRecipesSection(state.meals, theme);
                }
                return const SizedBox.shrink();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(_selectedCategory, style: theme.textTheme.titleLarge),
            ),
            CategoryChips(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) {
                setState(() => _selectedCategory = cat);
                context.read<MealListBloc>().add(LoadMealsByCategory(cat));
              },
            ),
            Expanded(
              child: BlocBuilder<MealListBloc, MealListState>(
                builder: (context, state) {
                  if (state is MealListLoading) {
                    return const ShimmerGrid();
                  } else if (state is MealListLoaded) {
                    final meals = state.meals;
                    if (meals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_off,
                                size: 40,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No meals found',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return MealGridView(meals: meals);
                  } else if (state is MealListError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<MealListBloc>().add(
                              LoadMealsByCategory(_selectedCategory),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRecipesSection(List<UserMeal> meals, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(AppStrings.myRecipes, style: theme.textTheme.titleLarge),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealDetailPage(mealId: meal.id),
                  ),
                ),
                child: SizedBox(
                  width: 130,
                  child: Card(
                    elevation: 3,
                    shadowColor: Colors.black26,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: meal.thumbnail.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: meal.thumbnail,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 260,
                                  placeholder: (_, __) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => const Center(
                                    child: Icon(Icons.restaurant, size: 32),
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.restaurant, size: 32),
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                          child: Text(
                            meal.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
