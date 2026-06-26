import '../../domain/entities/user_meal.dart';
import '../../domain/repositories/custom_meal_repo.dart';
import '../datasources/custom_meal_local_ds.dart';
import '../models/user_meal_model.dart';

class CustomMealRepositoryImpl implements CustomMealRepository {
  final CustomMealLocalDataSource dataSource;

  CustomMealRepositoryImpl(this.dataSource);

  @override
  Future<List<UserMeal>> getMeals() async {
    final models = await dataSource.getMeals();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveMeal(UserMeal meal) async {
    final model = UserMealModel.fromEntity(meal);
    await dataSource.saveMeal(model);
  }

  @override
  Future<void> deleteMeal(String id) => dataSource.deleteMeal(id);
}
