import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(), 
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home,
                color: currentIndex == 0 ? Colors.amber : Colors.grey),
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(Icons.search,
                color: currentIndex == 1 ? Colors.amber : Colors.grey),
            onPressed: () => onTap(1),
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: Icon(Icons.bookmark,
                color: currentIndex == 2 ? Colors.amber : Colors.grey),
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: currentIndex == 3 ? Colors.amber : Colors.grey),
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
