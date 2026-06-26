import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc/search_bloc.dart';
import '../bloc/search_bloc/search_state.dart';
import '../widgets/search_bar.dart';
import '../../../../core/widgets/meal_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _controller,
              autoFocus: true,
              onChanged: (query) =>
                  context.read<SearchBloc>().search(query),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  final results = state.results;
                  if (results.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return MealGridView(meals: results);
                }
                return const Center(
                  child: Text('Search for a meal'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
