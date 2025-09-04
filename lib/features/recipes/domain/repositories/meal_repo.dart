import '../entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMealsByCategory(String category);
  Future<List<Meal>> searchMeals(String query);
}
