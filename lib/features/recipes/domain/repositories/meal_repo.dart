
import '../entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMealsByCategory(String category);
}