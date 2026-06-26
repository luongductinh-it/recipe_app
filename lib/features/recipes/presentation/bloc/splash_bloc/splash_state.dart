import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final String thumbnailUrl;
  const SplashLoaded(this.thumbnailUrl);

  @override
  List<Object?> get props => [thumbnailUrl];
}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
