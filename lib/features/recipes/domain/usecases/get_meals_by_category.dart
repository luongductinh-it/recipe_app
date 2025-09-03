import '../entities/meal.dart';
import '../repositories/meal_repo.dart';

class GetMealsByCategory {
  final MealRepository repo;
  GetMealsByCategory(this.repo);

  Future<List<Meal>> call(String category) {
    return repo.getMealsByCategory(category);
  }
}
