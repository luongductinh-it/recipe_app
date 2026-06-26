import '../repositories/favorite_repo.dart';

class IsFavorite {
  final FavoriteRepository repo;
  IsFavorite(this.repo);

  Future<bool> call(String id) {
    return repo.isFavorite(id);
  }
}
