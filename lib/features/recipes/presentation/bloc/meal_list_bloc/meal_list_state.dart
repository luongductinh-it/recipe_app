import 'package:equatable/equatable.dart';
import '../../../domain/entities/meal.dart';

abstract class MealListState extends Equatable {
  const MealListState();

  @override
  List<Object?> get props => [];
}

class MealListInitial extends MealListState {}

class MealListLoading extends MealListState {}

class MealListLoaded extends MealListState {
  final List<Meal> meals;
  const MealListLoaded(this.meals);

  @override
  List<Object?> get props => [meals];
}

class MealListError extends MealListState {
  final String message;
  const MealListError(this.message);

  @override
  List<Object?> get props => [message];
}
