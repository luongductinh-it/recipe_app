import 'package:flutter_bloc/flutter_bloc.dart';
import 'meal_detail_event.dart';
import 'meal_detail_state.dart';
import '../../../domain/usecases/get_meal_detail.dart';

class MealDetailBloc extends Bloc<MealDetailEvent, MealDetailState> {
  final GetMealDetail getMealDetail;

  MealDetailBloc(this.getMealDetail) : super(MealDetailInitial()) {
    on<LoadMealDetail>((event, emit) async {
      emit(MealDetailLoading());
      try {
        final detail = await getMealDetail(event.mealId);
        emit(MealDetailLoaded(detail));
      } catch (e) {
        emit(MealDetailError(e.toString()));
      }
    });
  }
}
