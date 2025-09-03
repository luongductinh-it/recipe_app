import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/recipes/data/datasources/meal_remote_ds.dart';
import '../../features/recipes/data/repositories/meal_repo_impl.dart';
import '../../features/recipes/domain/usecases/get_meals_by_category.dart';
import '../../features/recipes/domain/repositories/meal_repo.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => ApiClient("https://www.themealdb.com/api/json/v1/1/"));

  // Data sources
  sl.registerLazySingleton<MealRemoteDataSource>(() => MealRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<MealRepository>(() => MealRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMealsByCategory(sl()));
}
