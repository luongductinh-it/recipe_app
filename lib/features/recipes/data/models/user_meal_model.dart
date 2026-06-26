import '../../domain/entities/meal_detail.dart';
import '../../domain/entities/user_meal.dart';

class UserMealModel {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<Ingredient> ingredients;
  final DateTime createdAt;

  const UserMealModel({
    required this.id,
    required this.name,
    this.thumbnail = '',
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
    required this.createdAt,
  });

  factory UserMealModel.fromEntity(UserMeal entity) => UserMealModel(
        id: entity.id,
        name: entity.name,
        thumbnail: entity.thumbnail,
        category: entity.category,
        area: entity.area,
        instructions: entity.instructions,
        ingredients: entity.ingredients,
        createdAt: entity.createdAt,
      );

  UserMeal toEntity() => UserMeal(
        id: id,
        name: name,
        thumbnail: thumbnail,
        category: category,
        area: area,
        instructions: instructions,
        ingredients: ingredients,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
        'category': category,
        'area': area,
        'instructions': instructions,
        'ingredients': ingredients
            .map((i) => {'name': i.name, 'measure': i.measure})
            .toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserMealModel.fromJson(Map<String, dynamic> json) => UserMealModel(
        id: json['id'] as String,
        name: json['name'] as String,
        thumbnail: json['thumbnail'] as String? ?? '',
        category: json['category'] as String? ?? '',
        area: json['area'] as String? ?? '',
        instructions: json['instructions'] as String? ?? '',
        ingredients: (json['ingredients'] as List<dynamic>?)
                ?.map((e) => Ingredient(
                      name: e['name'] as String? ?? '',
                      measure: e['measure'] as String? ?? '',
                    ))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );
}
