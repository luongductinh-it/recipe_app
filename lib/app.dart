import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/locator.dart';
import 'core/theme/app_theme.dart';
import 'features/recipes/domain/usecases/get_custom_meals.dart';
import 'features/recipes/domain/usecases/get_favorites.dart';
import 'features/recipes/domain/usecases/get_meal_detail.dart';
import 'features/recipes/domain/usecases/get_meals_by_category.dart';
import 'features/recipes/domain/usecases/is_favorite.dart';
import 'features/recipes/domain/usecases/remove_favorite.dart';
import 'features/recipes/domain/usecases/save_custom_meal.dart';
import 'features/recipes/domain/usecases/delete_custom_meal.dart';
import 'features/recipes/domain/usecases/search_meals.dart';
import 'features/recipes/domain/usecases/toggle_favorite.dart';
import 'features/recipes/presentation/bloc/meal_list_bloc/meal_list_bloc.dart';
import 'features/recipes/presentation/bloc/meal_detail_bloc/meal_detail_bloc.dart';
import 'features/recipes/presentation/bloc/search_bloc/search_bloc.dart';
import 'features/recipes/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'features/recipes/presentation/bloc/custom_meal_bloc/custom_meal_bloc.dart';
import 'features/recipes/presentation/bloc/splash_bloc/splash_bloc.dart';
import 'features/recipes/presentation/pages/splash_page.dart';
import 'features/recipes/presentation/pages/home_page.dart';
import 'features/recipes/presentation/pages/search_page.dart';
import 'features/recipes/presentation/pages/meal_detail_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MealListBloc(sl<GetMealsByCategory>()),
        ),
        BlocProvider(
          create: (_) => MealDetailBloc(sl<GetMealDetail>()),
        ),
        BlocProvider(
          create: (_) => SearchBloc(sl<SearchMeals>()),
        ),
        BlocProvider(
          create: (_) => FavoritesBloc(
            getFavorites: sl<GetFavorites>(),
            toggleFavorite: sl<ToggleFavorite>(),
            removeFavorite: sl<RemoveFavorite>(),
            isFavorite: sl<IsFavorite>(),
          ),
        ),
        BlocProvider(
          create: (_) => CustomMealBloc(
            getCustomMeals: sl<GetCustomMeals>(),
            saveCustomMeal: sl<SaveCustomMeal>(),
            deleteCustomMeal: sl<DeleteCustomMeal>(),
          ),
        ),
        BlocProvider(
          create: (_) => SplashBloc(sl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.generateRoute,
        home: const SplashPage(),
      ),
    );
  }
}

class AppRoutes {
  static const String home = '/home';
  static const String search = '/search';
  static const String mealDetail = '/meal-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case mealDetail:
        final mealId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MealDetailPage(mealId: mealId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
