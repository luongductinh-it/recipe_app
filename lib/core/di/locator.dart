import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/recipes/data/datasources/meal_remote_ds.dart';
import '../../features/recipes/data/repositories/meal_repo_impl.dart';
import '../../features/recipes/data/services/favorite_service.dart';
import '../../features/recipes/domain/repositories/meal_repo.dart';
import '../../features/recipes/domain/usecases/get_meals_by_category.dart';
import '../../features/recipes/domain/usecases/search_meals.dart';
import '../../features/recipes/domain/usecases/get_meal_detail.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(sl()),
  );

  // Services
  final favoriteService = FavoriteService();
  await favoriteService.init();
  sl.registerLazySingleton<FavoriteService>(() => favoriteService);

  // Repositories
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMealsByCategory(sl()));
  sl.registerLazySingleton(() => SearchMeals(sl()));
  sl.registerLazySingleton(() => GetMealDetail(sl()));
}
