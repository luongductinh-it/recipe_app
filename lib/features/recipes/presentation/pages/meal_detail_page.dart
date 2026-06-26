import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _ingredientsExpanded = true;
  bool _instructionsExpanded = true;

  @override
  void initState() {
    super.initState();
    context.read<MealDetailBloc>().add(LoadMealDetail(widget.mealId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

                final steps = detail.instructions
                    .split(RegExp(r'\n+'))
                    .where((s) => s.trim().isNotEmpty)
                    .toList();

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300,
                      pinned: true,
                      backgroundColor: theme.colorScheme.primary,
                      actions: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
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
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: 'meal_img_${detail.id}',
                              child: NetworkImageWithFallback(
                                url: detail.thumbnail,
                                fallbackIconSize: 64,
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black26],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.name,
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                AppChip.category(detail.category),
                                const SizedBox(width: 8),
                                AppChip.area(detail.area),
                              ],
                            ),
                            if (detail.tags != null && detail.tags!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: detail.tags!
                                      .split(',')
                                      .map((t) => AppChip.tag(t.trim()))
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: _collapsibleSection(
                          theme: theme,
                          icon: Icons.shopping_bag_outlined,
                          title: 'Ingredients (${detail.ingredients.length})',
                          expanded: _ingredientsExpanded,
                          onToggle: () =>
                              setState(() => _ingredientsExpanded = !_ingredientsExpanded),
                          child: Column(
                            children: detail.ingredients
                                .map((ing) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: theme.textTheme.bodyMedium,
                                                children: [
                                                  TextSpan(
                                                    text: ing.name,
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                  TextSpan(
                                                    text: '  —  ${ing.measure}',
                                                    style: TextStyle(
                                                      color: theme.colorScheme.onSurface
                                                          .withValues(alpha: 0.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _collapsibleSection(
                          theme: theme,
                          icon: Icons.menu_book_outlined,
                          title: 'Instructions',
                          expanded: _instructionsExpanded,
                          onToggle: () =>
                              setState(() => _instructionsExpanded = !_instructionsExpanded),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: steps.asMap().entries.map((e) {
                              final stepNum = e.key + 1;
                              final text = e.value.trim();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$stepNum',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        child: Column(
                          children: [
                            if (detail.youtubeUrl != null)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow_rounded),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  Widget _collapsibleSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(icon, size: 22, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleLarge),
                const Spacer(),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: child,
          secondChild: const SizedBox.shrink(),
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Future<void> _watchYoutube(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube')),
      );
    }
  }
}