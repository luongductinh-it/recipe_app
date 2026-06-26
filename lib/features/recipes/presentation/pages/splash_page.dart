import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/splash_bloc/splash_bloc.dart';
import '../bloc/splash_bloc/splash_event.dart';
import '../bloc/splash_bloc/splash_state.dart';
import 'main_shell.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(FetchRandomMeal());

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          final thumbUrl = state is SplashLoaded ? state.thumbnailUrl : null;

          return Stack(
            fit: StackFit.expand,
            children: [
              if (thumbUrl != null)
                Image.network(
                  thumbUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallback(theme),
                )
              else
                _buildFallback(theme),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),

              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Icon(
                        Icons.restaurant_rounded,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Bắt đầu với những món ăn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Khám phá công thức nấu ăn từ khắp nơi",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const MainShell(),
                              transitionsBuilder: (_, a, __, child) =>
                                  FadeTransition(opacity: a, child: child),
                              transitionDuration: const Duration(milliseconds: 400),
                            ),
                          );
                        },
                        child: const Text(
                          "Bắt đầu",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary,
      child: Center(
        child: Icon(Icons.restaurant, size: 80, color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }
}