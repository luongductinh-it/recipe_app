import 'meal_detail.dart';

class UserMeal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<Ingredient> ingredients;
  final DateTime createdAt;

  const UserMeal({
    required this.id,
    required this.name,
    this.thumbnail = '',
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
    required this.createdAt,
  });
}
