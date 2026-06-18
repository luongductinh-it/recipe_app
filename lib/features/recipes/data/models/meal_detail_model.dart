import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/meal_detail.dart';

part 'meal_detail_model.freezed.dart';
part 'meal_detail_model.g.dart';

@freezed
class MealDetailModel with _$MealDetailModel {
  const factory MealDetailModel({
    @JsonKey(name: "idMeal") required String id,
    @JsonKey(name: "strMeal") required String name,
    @JsonKey(name: "strMealThumb") required String thumbnail,
    @JsonKey(name: "strCategory") required String category,
    @JsonKey(name: "strArea") required String area,
    @JsonKey(name: "strInstructions") required String instructions,
    @JsonKey(name: "strTags") String? tags,
    @JsonKey(name: "strYoutube") String? youtubeUrl,
    @JsonKey(name: "strSource") String? sourceUrl,
    @JsonKey(name: "strIngredient1") String? strIngredient1,
    @JsonKey(name: "strIngredient2") String? strIngredient2,
    @JsonKey(name: "strIngredient3") String? strIngredient3,
    @JsonKey(name: "strIngredient4") String? strIngredient4,
    @JsonKey(name: "strIngredient5") String? strIngredient5,
    @JsonKey(name: "strIngredient6") String? strIngredient6,
    @JsonKey(name: "strIngredient7") String? strIngredient7,
    @JsonKey(name: "strIngredient8") String? strIngredient8,
    @JsonKey(name: "strIngredient9") String? strIngredient9,
    @JsonKey(name: "strIngredient10") String? strIngredient10,
    @JsonKey(name: "strIngredient11") String? strIngredient11,
    @JsonKey(name: "strIngredient12") String? strIngredient12,
    @JsonKey(name: "strIngredient13") String? strIngredient13,
    @JsonKey(name: "strIngredient14") String? strIngredient14,
    @JsonKey(name: "strIngredient15") String? strIngredient15,
    @JsonKey(name: "strIngredient16") String? strIngredient16,
    @JsonKey(name: "strIngredient17") String? strIngredient17,
    @JsonKey(name: "strIngredient18") String? strIngredient18,
    @JsonKey(name: "strIngredient19") String? strIngredient19,
    @JsonKey(name: "strIngredient20") String? strIngredient20,
    @JsonKey(name: "strMeasure1") String? strMeasure1,
    @JsonKey(name: "strMeasure2") String? strMeasure2,
    @JsonKey(name: "strMeasure3") String? strMeasure3,
    @JsonKey(name: "strMeasure4") String? strMeasure4,
    @JsonKey(name: "strMeasure5") String? strMeasure5,
    @JsonKey(name: "strMeasure6") String? strMeasure6,
    @JsonKey(name: "strMeasure7") String? strMeasure7,
    @JsonKey(name: "strMeasure8") String? strMeasure8,
    @JsonKey(name: "strMeasure9") String? strMeasure9,
    @JsonKey(name: "strMeasure10") String? strMeasure10,
    @JsonKey(name: "strMeasure11") String? strMeasure11,
    @JsonKey(name: "strMeasure12") String? strMeasure12,
    @JsonKey(name: "strMeasure13") String? strMeasure13,
    @JsonKey(name: "strMeasure14") String? strMeasure14,
    @JsonKey(name: "strMeasure15") String? strMeasure15,
    @JsonKey(name: "strMeasure16") String? strMeasure16,
    @JsonKey(name: "strMeasure17") String? strMeasure17,
    @JsonKey(name: "strMeasure18") String? strMeasure18,
    @JsonKey(name: "strMeasure19") String? strMeasure19,
    @JsonKey(name: "strMeasure20") String? strMeasure20,
  }) = _MealDetailModel;

  factory MealDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MealDetailModelFromJson(json);
}

extension MealDetailModelX on MealDetailModel {
  MealDetail toEntity() {
    final ingredients = <Ingredient>[];
    final ingredientKeys = [
      strIngredient1, strIngredient2, strIngredient3, strIngredient4,
      strIngredient5, strIngredient6, strIngredient7, strIngredient8,
      strIngredient9, strIngredient10, strIngredient11, strIngredient12,
      strIngredient13, strIngredient14, strIngredient15, strIngredient16,
      strIngredient17, strIngredient18, strIngredient19, strIngredient20,
    ];
    final measureKeys = [
      strMeasure1, strMeasure2, strMeasure3, strMeasure4,
      strMeasure5, strMeasure6, strMeasure7, strMeasure8,
      strMeasure9, strMeasure10, strMeasure11, strMeasure12,
      strMeasure13, strMeasure14, strMeasure15, strMeasure16,
      strMeasure17, strMeasure18, strMeasure19, strMeasure20,
    ];

    for (int i = 0; i < 20; i++) {
      final name = ingredientKeys[i]?.trim();
      final measure = measureKeys[i]?.trim();
      if (name != null && name.isNotEmpty) {
        ingredients.add(Ingredient(
          name: name,
          measure: measure ?? '',
        ));
      }
    }

    return MealDetail(
      id: id,
      name: name,
      thumbnail: thumbnail,
      category: category,
      area: area,
      instructions: instructions,
      ingredients: ingredients,
      tags: tags,
      youtubeUrl: youtubeUrl,
      sourceUrl: sourceUrl,
    );
  }
}
