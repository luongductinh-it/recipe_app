import '../entities/meal.dart';
import '../repositories/favorite_repo.dart';

class GetFavorites {
  final FavoriteRepository repo;
  GetFavorites(this.repo);

  Future<List<Meal>> call() {
    return repo.getFavorites();
  }
}
