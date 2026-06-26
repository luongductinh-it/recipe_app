import '../entities/user_meal.dart';
import '../repositories/custom_meal_repo.dart';

class SaveCustomMeal {
  final CustomMealRepository repo;
  SaveCustomMeal(this.repo);

  Future<void> call(UserMeal meal) {
    return repo.saveMeal(meal);
  }
}
