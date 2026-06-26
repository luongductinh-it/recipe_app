import '../entities/user_meal.dart';

abstract class CustomMealRepository {
  Future<List<UserMeal>> getMeals();
  Future<void> saveMeal(UserMeal meal);
  Future<void> deleteMeal(String id);
}
