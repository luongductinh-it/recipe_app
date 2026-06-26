import '../entities/meal.dart';
import '../repositories/favorite_repo.dart';

class ToggleFavorite {
  final FavoriteRepository repo;
  ToggleFavorite(this.repo);

  Future<void> call(Meal meal) {
    return repo.toggleFavorite(meal);
  }
}
