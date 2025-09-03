import '../../../../core/network/api_client.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMealsByCategory(String category);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final ApiClient client;
  MealRemoteDataSourceImpl(this.client);

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final data = await client.get('filter.php?c=$category');
    final meals = (data['meals'] as List)
        .map((json) => MealModel.fromJson(json))
        .toList();
    return meals;
  }
}
