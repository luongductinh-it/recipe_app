import 'package:equatable/equatable.dart';

abstract class MealListEvent extends Equatable {
  const MealListEvent();

  @override
  List<Object?> get props => [];
}

class LoadMealsByCategory extends MealListEvent {
  final String category;
  const LoadMealsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}