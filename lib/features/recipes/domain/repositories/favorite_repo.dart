import '../entities/meal.dart';

abstract class FavoriteRepository {
  Future<List<Meal>> getFavorites();
  Future<void> addFavorite(Meal meal);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<void> toggleFavorite(Meal meal);
}
