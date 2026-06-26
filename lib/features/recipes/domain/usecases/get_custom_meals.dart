import '../entities/user_meal.dart';
import '../repositories/custom_meal_repo.dart';

class GetCustomMeals {
  final CustomMealRepository repo;
  GetCustomMeals(this.repo);

  Future<List<UserMeal>> call() {
    return repo.getMeals();
  }
}
