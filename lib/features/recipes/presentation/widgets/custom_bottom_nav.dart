import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkSurface
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black38
                : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _navItem(Icons.search_outlined, Icons.search, 'Search', 1),
              const SizedBox(width: 40),
              _navItem(Icons.bookmark_outline, Icons.bookmark, 'Saved', 2),
              _navItem(Icons.person_outline, Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData outlineIcon, IconData filledIcon, String label, int index) {
    final isActive = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accentAmber.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? filledIcon : outlineIcon,
                  key: ValueKey(isActive),
                  size: 22,
                  color: isActive ? AppColors.navActive : AppColors.navInactive,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.navActive : AppColors.navInactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}