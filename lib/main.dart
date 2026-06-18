import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const App());
}
