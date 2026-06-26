import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/search_bloc/search_bloc.dart';
import '../bloc/search_bloc/search_state.dart';
import '../widgets/search_bar.dart';
import '../../../../core/widgets/meal_grid.dart';
import '../../../../core/widgets/shimmer_grid.dart';

const _kRecentKey = 'recent_searches';
const _kMaxRecent = 8;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recentSearches = prefs.getStringList(_kRecentKey) ?? []);
  }

  Future<void> _saveRecent(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = (prefs.getStringList(_kRecentKey) ?? []);
    list.remove(query);
    list.insert(0, query);
    if (list.length > _kMaxRecent) list.removeLast();
    await prefs.setStringList(_kRecentKey, list);
    setState(() => _recentSearches = list);
  }

  Future<void> _clearRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRecentKey);
    setState(() => _recentSearches = []);
  }

  void _onSubmit(String query) {
    if (query.trim().isEmpty) return;
    _saveRecent(query.trim());
    context.read<SearchBloc>().search(query.trim());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _controller,
              autoFocus: true,
              onChanged: (query) => context.read<SearchBloc>().search(query),
              onSubmitted: _onSubmit,
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const ShimmerGrid();
                } else if (state is SearchLoaded) {
                  final results = state.results;
                  if (results.isEmpty) {
                    return _buildNoResults(theme);
                  }
                  return MealGridView(meals: results);
                }

                if (_recentSearches.isNotEmpty) {
                  return _buildRecentList(theme);
                }
                return _buildInitial(theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent searches', style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: _clearRecent,
                child: const Text('Clear', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: _recentSearches
                .map((q) => ListTile(
                      leading: Icon(Icons.history, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                      title: Text(q),
                      trailing: Icon(Icons.arrow_upward, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                      dense: true,
                      onTap: () {
                        _controller.text = q;
                        _controller.selection = TextSelection.fromPosition(TextPosition(offset: q.length));
                        _onSubmit(q);
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off, size: 40,
                color: theme.colorScheme.error.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 16),
          Text('No results found',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 4),
          Text('Try a different search term',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35))),
        ],
      ),
    );
  }

  Widget _buildInitial(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          ),
          const SizedBox(height: 20),
          Text('Search for a meal',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 4),
          Text('Type in the search bar above',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35))),
        ],
      ),
    );
  }
}