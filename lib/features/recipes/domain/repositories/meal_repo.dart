import '../entities/meal.dart';
import '../entities/meal_detail.dart';

abstract class MealRepository {
  Future<List<Meal>> getMealsByCategory(String category);
  Future<List<Meal>> searchMeals(String query);
  Future<MealDetail> getMealDetail(String id);
}
