import '../repositories/favorite_repo.dart';

class RemoveFavorite {
  final FavoriteRepository repo;
  RemoveFavorite(this.repo);

  Future<void> call(String id) {
    return repo.removeFavorite(id);
  }
}
