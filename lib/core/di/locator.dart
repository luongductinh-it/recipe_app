import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/recipes/data/datasources/custom_meal_local_ds.dart';
import '../../features/recipes/data/datasources/favorite_local_ds.dart';
import '../../features/recipes/data/datasources/meal_remote_ds.dart';
import '../../features/recipes/data/repositories/custom_meal_repo_impl.dart';
import '../../features/recipes/data/repositories/favorite_repo_impl.dart';
import '../../features/recipes/data/repositories/meal_repo_impl.dart';
import '../../features/recipes/domain/repositories/custom_meal_repo.dart';
import '../../features/recipes/domain/repositories/favorite_repo.dart';
import '../../features/recipes/domain/repositories/meal_repo.dart';
import '../../features/recipes/domain/usecases/delete_custom_meal.dart';
import '../../features/recipes/domain/usecases/get_custom_meals.dart';
import '../../features/recipes/domain/usecases/get_favorites.dart';
import '../../features/recipes/domain/usecases/get_meal_detail.dart';
import '../../features/recipes/domain/usecases/get_meals_by_category.dart';
import '../../features/recipes/domain/usecases/is_favorite.dart';
import '../../features/recipes/domain/usecases/remove_favorite.dart';
import '../../features/recipes/domain/usecases/save_custom_meal.dart';
import '../../features/recipes/domain/usecases/search_meals.dart';
import '../../features/recipes/domain/usecases/toggle_favorite.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(sl()),
  );

  final favoriteDs = FavoriteLocalDataSourceImpl();
  await favoriteDs.init();
  sl.registerLazySingleton<FavoriteLocalDataSource>(() => favoriteDs);

  final customMealDs = CustomMealLocalDataSourceImpl();
  await customMealDs.init();
  sl.registerLazySingleton<CustomMealLocalDataSource>(() => customMealDs);

  // Repositories
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CustomMealRepository>(
    () => CustomMealRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMealsByCategory(sl()));
  sl.registerLazySingleton(() => SearchMeals(sl()));
  sl.registerLazySingleton(() => GetMealDetail(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));
  sl.registerLazySingleton(() => GetCustomMeals(sl()));
  sl.registerLazySingleton(() => SaveCustomMeal(sl()));
  sl.registerLazySingleton(() => DeleteCustomMeal(sl()));
}
