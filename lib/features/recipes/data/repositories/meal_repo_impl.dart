import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_detail.dart';
import '../../domain/repositories/meal_repo.dart';
import '../datasources/meal_remote_ds.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

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

  @override
  Future<MealDetail> getMealDetail(String id) async {
    final model = await remoteDataSource.getMealDetail(id);
    return model.toEntity();
  }
}
