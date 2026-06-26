import 'package:equatable/equatable.dart';
import '../../../domain/entities/meal.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Meal meal;
  const ToggleFavoriteEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String id;
  const RemoveFavoriteEvent(this.id);

  @override
  List<Object?> get props => [id];
}
