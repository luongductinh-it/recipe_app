import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncSnapshot<T>? snapshot;
  final T? data;
  final bool isLoading;
  final String? errorMessage;
  final Widget Function(T data) onData;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const AsyncValueWidget({
    super.key,
    this.snapshot,
    this.data,
    required this.isLoading,
    this.errorMessage,
    required this.onData,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return errorWidget ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(color: AppColors.errorRed, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
    }

    final value = data;
    if (value != null) {
      return onData(value);
    }

    return const SizedBox.shrink();
  }
}
