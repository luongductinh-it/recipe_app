import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/di/locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs: prefs));
}
