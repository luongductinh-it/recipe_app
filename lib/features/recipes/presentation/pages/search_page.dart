import 'package:flutter/material.dart';
import 'package:recipe_app/core/di/locator.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal.dart';
import 'package:recipe_app/features/recipes/domain/repositories/meal_repo.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Meal> _results = [];
  bool _isLoading = false;

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = sl<MealRepository>();
      final meals = await repo.searchMeals(query);
      setState(() => _results = meals);
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                controller: _controller,
                autoFocus: true,
                onChanged: _searchMeals,
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final meal = _results[index];
                        return ListTile(
                          title: Text(meal.name),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.amber),
                          onTap: () {
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
