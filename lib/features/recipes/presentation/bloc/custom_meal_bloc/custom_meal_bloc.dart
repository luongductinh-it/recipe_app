import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_meal_event.dart';
import 'custom_meal_state.dart';
import '../../../domain/usecases/get_custom_meals.dart';
import '../../../domain/usecases/save_custom_meal.dart';
import '../../../domain/usecases/delete_custom_meal.dart';

class CustomMealBloc extends Bloc<CustomMealEvent, CustomMealState> {
  final GetCustomMeals getCustomMeals;
  final SaveCustomMeal saveCustomMeal;
  final DeleteCustomMeal deleteCustomMeal;

  CustomMealBloc({
    required this.getCustomMeals,
    required this.saveCustomMeal,
    required this.deleteCustomMeal,
  }) : super(CustomMealInitial()) {
    on<LoadCustomMeals>((event, emit) async {
      emit(CustomMealLoading());
      try {
        final meals = await getCustomMeals();
        emit(CustomMealLoaded(meals));
      } catch (e) {
        emit(CustomMealError(e.toString()));
      }
    });

    on<SaveCustomMealEvent>((event, emit) async {
      try {
        await saveCustomMeal(event.meal);
        final meals = await getCustomMeals();
        emit(CustomMealLoaded(meals));
      } catch (e) {
        emit(CustomMealError(e.toString()));
      }
    });

    on<DeleteCustomMealEvent>((event, emit) async {
      try {
        await deleteCustomMeal(event.id);
        final meals = await getCustomMeals();
        emit(CustomMealLoaded(meals));
      } catch (e) {
        emit(CustomMealError(e.toString()));
      }
    });
  }
}
