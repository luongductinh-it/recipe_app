import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        secondary: AppColors.accentAmber,
        surface: AppColors.surfaceLight,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: Colors.black87,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentAmber,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentAmber,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.chipSelected,
        backgroundColor: AppColors.greyLight,
        labelStyle: GoogleFonts.nunito(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: AppColors.greyMedium,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.greyLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        secondary: AppColors.accentAmber,
        surface: AppColors.darkSurface,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          height: 1.6,
          color: AppColors.darkText,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: AppColors.darkText,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      )),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentAmber,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentAmber,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.chipSelected,
        backgroundColor: AppColors.darkCard,
        labelStyle: GoogleFonts.nunito(fontSize: 13, color: AppColors.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.accentAmber,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black38,
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: AppColors.darkTextSecondary,
        hintStyle: TextStyle(color: AppColors.darkTextSecondary),
        labelStyle: TextStyle(color: AppColors.darkTextSecondary),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}