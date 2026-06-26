import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import '../../../domain/usecases/remove_favorite.dart';
import '../../../domain/usecases/is_favorite.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;
  final RemoveFavorite removeFavorite;
  final IsFavorite isFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
    required this.removeFavorite,
    required this.isFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await getFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      try {
        await toggleFavorite(event.meal);
        final favorites = await getFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      try {
        await removeFavorite(event.id);
        final favorites = await getFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });
  }
}
