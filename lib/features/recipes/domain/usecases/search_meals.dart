import '../entities/meal.dart';
import '../repositories/meal_repo.dart';

class SearchMeals {
  final MealRepository repo;
  SearchMeals(this.repo);

  Future<List<Meal>> call(String query) {
    return repo.searchMeals(query);
  }
}
