import '../entities/meal_detail.dart';
import '../repositories/meal_repo.dart';

class GetMealDetail {
  final MealRepository repo;
  GetMealDetail(this.repo);

  Future<MealDetail> call(String id) {
    return repo.getMealDetail(id);
  }
}
