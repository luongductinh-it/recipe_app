import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_meal.dart';

abstract class CustomMealState extends Equatable {
  const CustomMealState();

  @override
  List<Object?> get props => [];
}

class CustomMealInitial extends CustomMealState {}

class CustomMealLoading extends CustomMealState {}

class CustomMealLoaded extends CustomMealState {
  final List<UserMeal> meals;
  const CustomMealLoaded(this.meals);

  @override
  List<Object?> get props => [meals];
}

class CustomMealError extends CustomMealState {
  final String message;
  const CustomMealError(this.message);

  @override
  List<Object?> get props => [message];
}
