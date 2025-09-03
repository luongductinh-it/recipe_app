import '../models/meal_model.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repo.dart';
import '../datasources/meal_remote_ds.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remote;
  MealRepositoryImpl(this.remote);

  @override
  Future<List<Meal>> getMealsByCategory(String category) async {
    final models = await remote.getMealsByCategory(category);
    return models.map((m) => m.toEntity()).toList();
  }
}
