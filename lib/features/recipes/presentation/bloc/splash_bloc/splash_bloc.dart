import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final http.Client client;

  SplashBloc(this.client) : super(SplashInitial()) {
    on<FetchRandomMeal>((event, emit) async {
      try {
        final url = Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/random.php',
        );
        final res = await client.get(url);

        if (res.statusCode != 200) {
          emit(const SplashError('Failed to fetch random meal'));
          return;
        }

        final data = json.decode(res.body);
        final meal = data['meals'][0];
        final thumb = meal['strMealThumb'] as String;
        emit(SplashLoaded(thumb));
      } catch (e) {
        emit(SplashError(e.toString()));
      }
    });
  }
}
