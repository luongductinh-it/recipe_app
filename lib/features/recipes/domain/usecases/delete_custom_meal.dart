import '../repositories/custom_meal_repo.dart';

class DeleteCustomMeal {
  final CustomMealRepository repo;
  DeleteCustomMeal(this.repo);

  Future<void> call(String id) {
    return repo.deleteMeal(id);
  }
}
