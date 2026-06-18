class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<Ingredient> ingredients;
  final String? tags;
  final String? youtubeUrl;
  final String? sourceUrl;

  const MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
    this.tags,
    this.youtubeUrl,
    this.sourceUrl,
  });
}
