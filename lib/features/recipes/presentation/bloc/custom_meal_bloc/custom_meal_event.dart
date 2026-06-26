import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_meal.dart';

abstract class CustomMealEvent extends Equatable {
  const CustomMealEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomMeals extends CustomMealEvent {}

class SaveCustomMealEvent extends CustomMealEvent {
  final UserMeal meal;
  const SaveCustomMealEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class DeleteCustomMealEvent extends CustomMealEvent {
  final String id;
  const DeleteCustomMealEvent(this.id);

  @override
  List<Object?> get props => [id];
}
