import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/meal_list_bloc/meal_list_bloc.dart';
import '../bloc/meal_list_bloc/meal_list_event.dart';
import '../bloc/meal_list_bloc/meal_list_state.dart';
import '../widgets/search_bar.dart';
import '../../../../core/widgets/category_chips.dart';
import '../../../../core/widgets/meal_grid.dart';

const List<String> _categories = [
  'Seafood',
  'Dessert',
  'Chicken',
  'Beef',
  'Pasta',
  'Vegetarian',
  'Breakfast',
];

class HomePage extends StatefulWidget {
  final VoidCallback? onSearchTap;
  const HomePage({super.key, this.onSearchTap});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Seafood';

  @override
  void initState() {
    super.initState();
    context.read<MealListBloc>().add(LoadMealsByCategory(_selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SearchBarWidget(
              onTap: widget.onSearchTap,
            ),
          ),
          CategoryChips(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) {
              setState(() => _selectedCategory = cat);
              context
                  .read<MealListBloc>()
                  .add(LoadMealsByCategory(cat));
            },
          ),
          Expanded(
            child: BlocBuilder<MealListBloc, MealListState>(
              builder: (context, state) {
                if (state is MealListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MealListLoaded) {
                  final meals = state.meals;
                  if (meals.isEmpty) {
                    return const Center(child: Text('No meals found'));
                  }
                  return MealGridView(meals: meals);
                } else if (state is MealListError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
