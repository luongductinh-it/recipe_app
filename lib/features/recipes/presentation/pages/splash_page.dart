import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main_shell.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? mealThumb;

  @override
  void initState() {
    super.initState();
    _fetchRandomMeal();
  }

  Future<void> _fetchRandomMeal() async {
    final url = Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final meal = data["meals"][0];
      setState(() {
        mealThumb = meal["strMealThumb"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          mealThumb != null
              ? Image.network(
                  mealThumb!,
                  fit: BoxFit.cover,
                )
              : const SizedBox(),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Bắt đầu với những món ăn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainShell()),
                    );
                  },
                  child: const Text("Bắt đầu"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
