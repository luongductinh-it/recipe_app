import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_meal_model.dart';

abstract class CustomMealLocalDataSource {
  Future<List<UserMealModel>> getMeals();
  Future<void> saveMeal(UserMealModel meal);
  Future<void> deleteMeal(String id);
}

class CustomMealLocalDataSourceImpl implements CustomMealLocalDataSource {
  SharedPreferences? _prefs;
  static const String _key = 'custom_meals';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<List<UserMealModel>> getMeals() async {
    final strings = _prefs?.getStringList(_key) ?? [];
    return strings
        .map((s) => UserMealModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> saveMeal(UserMealModel meal) async {
    final meals = await getMeals();
    meals.insert(0, meal);
    await _save(meals);
  }

  @override
  Future<void> deleteMeal(String id) async {
    final meals = await getMeals();
    meals.removeWhere((m) => m.id == id);
    await _save(meals);
  }

  Future<void> _save(List<UserMealModel> meals) async {
    await _prefs?.setStringList(
      _key,
      meals.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }
}
