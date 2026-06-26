import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc/favorites_bloc.dart';
import '../bloc/favorites_bloc/favorites_event.dart';
import '../bloc/custom_meal_bloc/custom_meal_bloc.dart';
import '../bloc/custom_meal_bloc/custom_meal_event.dart';
import '../widgets/custom_bottom_nav.dart';
import 'add_meal_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(onSearchTap: () => setState(() => _currentIndex = 1)),
          const SearchPage(),
          const FavoritesPage(),
          const ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMealPage()),
          );
          if (!context.mounted) return;
          context.read<CustomMealBloc>().add(LoadCustomMeals());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            context.read<FavoritesBloc>().add(LoadFavorites());
          }
        },
      ),
    );
  }
}
