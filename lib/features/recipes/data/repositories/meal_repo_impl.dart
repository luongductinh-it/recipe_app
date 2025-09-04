import 'package:recipe_app/features/recipes/data/models/meal_model.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repo.dart';
import '../datasources/meal_remote_ds.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Meal>> getMealsByCategory(String category) async {
    final models = await remoteDataSource.getMealsByCategory(category);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Meal>> searchMeals(String query) async {
    final models = await remoteDataSource.searchMeals(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
