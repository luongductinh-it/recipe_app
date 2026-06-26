import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../features/recipes/domain/entities/meal.dart';
import '../../features/recipes/presentation/pages/meal_detail_page.dart';

class HomeBanner extends StatefulWidget {
  final List<Meal> meals;
  const HomeBanner({super.key, required this.meals});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final _pageCtrl = PageController();
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(HomeBanner old) {
    super.didUpdateWidget(old);
    if (old.meals != widget.meals) {
      _current = 0;
      _timer?.cancel();
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (widget.meals.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      _current = (_current + 1) % widget.meals.length;
      _pageCtrl.animateToPage(
        _current,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.meals.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => _current = i,
            itemCount: widget.meals.length,
            itemBuilder: (_, i) => _buildSlide(theme, widget.meals[i]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.meals.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _current == i ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _current == i
                        ? theme.colorScheme.secondary
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(ThemeData theme, Meal meal) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailPage(mealId: meal.id),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: meal.thumbnail,
                fit: BoxFit.cover,
                memCacheWidth: 700,
                errorWidget: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Text(
                  meal.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
