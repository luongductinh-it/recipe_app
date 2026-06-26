import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../../domain/usecases/search_meals.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMeals searchMeals;
  Timer? _debounce;

  SearchBloc(this.searchMeals) : super(SearchInitial()) {
    on<SearchMealsEvent>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      try {
        final meals = await searchMeals(event.query);
        emit(SearchLoaded(meals));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    on<ClearSearch>((event, emit) {
      _debounce?.cancel();
      emit(SearchInitial());
    });
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      add(SearchMealsEvent(query));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
