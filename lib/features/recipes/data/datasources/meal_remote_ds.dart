import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<List<MealModel>> searchMeals(String query);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final http.Client client;
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  MealRemoteDataSourceImpl(this.client);

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final response =
        await client.get(Uri.parse("$baseUrl/filter.php?c=$category"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception("Failed to load meals by category");
    }
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final response =
        await client.get(Uri.parse("$baseUrl/search.php?s=$query"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception("Failed to search meals");
    }
  }
}
