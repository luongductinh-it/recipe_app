import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/meal.dart';

abstract class FavoriteLocalDataSource {
  Future<List<Meal>> getFavorites();
  Future<void> addFavorite(Meal meal);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<void> toggleFavorite(Meal meal);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  SharedPreferences? _prefs;
  static const String _key = 'favorite_meals';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<List<Meal>> getFavorites() async {
    final strings = _prefs?.getStringList(_key) ?? [];
    return strings.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return Meal(
        id: map['idMeal'] as String,
        name: map['strMeal'] as String,
        thumbnail: map['strMealThumb'] as String,
      );
    }).toList();
  }

  @override
  Future<void> addFavorite(Meal meal) async {
    final favorites = await getFavorites();
    if (favorites.any((m) => m.id == meal.id)) return;
    favorites.add(meal);
    await _save(favorites);
  }

  @override
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == id);
    await _save(favorites);
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == id);
  }

  @override
  Future<void> toggleFavorite(Meal meal) async {
    final favorites = await getFavorites();
    final existing = favorites.indexWhere((m) => m.id == meal.id);
    if (existing >= 0) {
      favorites.removeAt(existing);
    } else {
      favorites.add(meal);
    }
    await _save(favorites);
  }

  Future<void> _save(List<Meal> favorites) async {
    await _prefs?.setStringList(
      _key,
      favorites.map((m) => jsonEncode({
        'idMeal': m.id,
        'strMeal': m.name,
        'strMealThumb': m.thumbnail,
      })).toList(),
    );
  }
}
