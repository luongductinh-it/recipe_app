import 'package:flutter_bloc/flutter_bloc.dart';
import 'meal_list_event.dart';
import 'meal_list_state.dart';
import '../../../domain/usecases/get_meals_by_category.dart';

class MealListBloc extends Bloc<MealListEvent, MealListState> {
  final GetMealsByCategory getMealsByCategory;

  MealListBloc(this.getMealsByCategory) : super(MealListInitial()) {
    on<LoadMealsByCategory>((event, emit) async {
      emit(MealListLoading());
      try {
        final meals = await getMealsByCategory(event.category);
        emit(MealListLoaded(meals));
      } catch (e) {
        emit(MealListError(e.toString()));
      }
    });
  }
}
