import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import '../bloc/favorites_bloc/favorites_bloc.dart';
import '../bloc/favorites_bloc/favorites_event.dart';
import '../bloc/favorites_bloc/favorites_state.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/meal_grid.dart';
import '../../../../core/widgets/shimmer_grid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/meal_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  bool _selectMode = false;
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  void refresh() {
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
        if (_selected.isEmpty) _selectMode = false;
      } else {
        _selected.add(id);
      }
    });
  }

  void _exitSelect() {
    setState(() {
      _selectMode = false;
      _selected.clear();
    });
  }

  void _deleteSelected() {
    if (_selected.isEmpty) return;
    for (final id in _selected) {
      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(id));
    }
    _exitSelect();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectMode ? '${_selected.length} selected' : AppStrings.favoritesTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectMode) ...[
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.favoriteRed,
                        onPressed: _selected.isNotEmpty ? _deleteSelected : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _exitSelect,
                      ),
                    ] else
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        onSelected: (v) {
                          if (v == 'select') {
                            setState(() => _selectMode = true);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'select', child: Text('Select items')),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading) {
                  return const ShimmerGrid();
                } else if (state is FavoritesLoaded) {
                  final favorites = state.favorites;
                  if (favorites.isEmpty) {
                    return const EmptyState(
                      icon: Icons.bookmark_border,
                      message: AppStrings.emptyFavorites,
                      subtitle: 'Save your favorite recipes to see them here',
                    );
                  }
                  if (_selectMode) {
                    return _buildSelectableGrid(favorites, theme);
                  }
                  return MealGridView(meals: favorites);
                } else if (state is FavoritesError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableGrid(List<Meal> meals, ThemeData theme) {
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
        final isSelected = _selected.contains(meal.id);
        return GestureDetector(
          onTap: () => _toggleSelect(meal.id),
          child: Stack(
            children: [
              MealCard(
                meal: meal,
                onTap: () => _toggleSelect(meal.id),
              ),
              if (isSelected)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
              if (!isSelected)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}