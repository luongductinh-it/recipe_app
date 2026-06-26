import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import '../bloc/meal_detail_bloc/meal_detail_bloc.dart';
import '../bloc/meal_detail_bloc/meal_detail_event.dart';
import '../bloc/meal_detail_bloc/meal_detail_state.dart';
import '../bloc/favorites_bloc/favorites_bloc.dart';
import '../bloc/favorites_bloc/favorites_event.dart';
import '../bloc/favorites_bloc/favorites_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/network_image_fallback.dart';

class MealDetailPage extends StatefulWidget {
  final String mealId;
  const MealDetailPage({super.key, required this.mealId});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MealDetailBloc>().add(LoadMealDetail(widget.mealId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, favState) {},
        builder: (context, favState) {
          final isFavorite = favState is FavoritesLoaded &&
              favState.favorites.any((m) => m.id == widget.mealId);

          return BlocBuilder<MealDetailBloc, MealDetailState>(
            builder: (context, state) {
              if (state is MealDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MealDetailLoaded) {
                final detail = state.mealDetail;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 280,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? AppColors.favoriteRed
                                : Colors.white,
                          ),
                          onPressed: () {
                            final meal = Meal(
                              id: detail.id,
                              name: detail.name,
                              thumbnail: detail.thumbnail,
                            );
                            context
                                .read<FavoritesBloc>()
                                .add(ToggleFavoriteEvent(meal));
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: NetworkImageWithFallback(
                          url: detail.thumbnail,
                          fallbackIconSize: 64,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                AppChip.category(detail.category),
                                const SizedBox(width: 8),
                                AppChip.area(detail.area),
                              ],
                            ),
                            if (detail.tags != null && detail.tags!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: detail.tags!
                                      .split(',')
                                      .map((t) => AppChip.tag(t.trim()))
                                      .toList(),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              'Ingredients',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            ...detail.ingredients.map(
                              (ing) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle,
                                        size: 8, color: AppColors.primaryTeal),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${ing.name} — ${ing.measure}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Instructions',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              detail.instructions,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 24),
                            if (detail.youtubeUrl != null)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Watch on YouTube'),
                                ),
                              ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is MealDetailError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(
                          color: AppColors.errorRed, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
