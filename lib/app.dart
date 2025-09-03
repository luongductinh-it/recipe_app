import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/locator.dart';
import 'features/recipes/presentation/bloc/meal_list_bloc/meal_list_bloc.dart';
import 'features/recipes/domain/usecases/get_meals_by_category.dart';
import 'features/recipes/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MealListBloc(sl<GetMealsByCategory>()),
        ),
      ],
      child: MaterialApp(
        title: 'Recipe App',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const HomePage(),
      ),
    );
  }
}
