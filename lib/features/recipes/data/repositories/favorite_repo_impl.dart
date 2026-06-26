import '../../domain/entities/meal.dart';
import '../../domain/repositories/favorite_repo.dart';
import '../datasources/favorite_local_ds.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource dataSource;

  FavoriteRepositoryImpl(this.dataSource);

  @override
  Future<List<Meal>> getFavorites() => dataSource.getFavorites();

  @override
  Future<void> addFavorite(Meal meal) => dataSource.addFavorite(meal);

  @override
  Future<void> removeFavorite(String id) => dataSource.removeFavorite(id);

  @override
  Future<bool> isFavorite(String id) => dataSource.isFavorite(id);

  @override
  Future<void> toggleFavorite(Meal meal) => dataSource.toggleFavorite(meal);
}
