import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF7B61FF);
  static const secondary = Color(0xFF0088FF);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF6F7FB);
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);

  static const darkBackground = Color(0xFF111827);
  static const darkSurface = Color(0xFF1F2937);
  static const darkTextPrimary = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFF9BA3AF);
}

class AppTheme {
  static ThemeData light({Color seedColor = AppColors.primary}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: GoogleFonts.vazirmatn().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        primary: seedColor,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.lightSurface,
      ),
      textTheme: _textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      filledButtonTheme: _filledButtonTheme(seedColor),
      inputDecorationTheme: _inputDecorationTheme(AppColors.lightSurface),
      cardTheme: _cardTheme(AppColors.lightBackground),
      appBarTheme: _appBarTheme(AppColors.lightBackground, AppColors.lightTextPrimary),
      bottomNavigationBarTheme: _bottomNavTheme(AppColors.lightBackground, seedColor),
    );
  }

  static ThemeData dark({Color seedColor = AppColors.primary}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: GoogleFonts.vazirmatn().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        primary: seedColor,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.darkSurface,
      ),
      textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      filledButtonTheme: _filledButtonTheme(seedColor),
      inputDecorationTheme: _inputDecorationTheme(AppColors.darkSurface),
      cardTheme: _cardTheme(AppColors.darkSurface),
      appBarTheme: _appBarTheme(AppColors.darkBackground, AppColors.darkTextPrimary),
      bottomNavigationBarTheme: _bottomNavTheme(AppColors.darkBackground, seedColor),
    );
  }

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.vazirmatnTextTheme();
    return base.copyWith(
      headlineMedium: GoogleFonts.vazirmatn(fontSize: 24, fontWeight: FontWeight.bold, color: primaryText),
      titleLarge: GoogleFonts.vazirmatn(fontSize: 18, fontWeight: FontWeight.w600, color: primaryText),
      bodyLarge: GoogleFonts.vazirmatn(fontSize: 15, color: primaryText),
      bodyMedium: GoogleFonts.vazirmatn(fontSize: 14, color: secondaryText),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(Color color) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.vazirmatn(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Color fillColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static CardThemeData _cardTheme(Color color) {
    return CardThemeData(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    );
  }

  static AppBarTheme _appBarTheme(Color bg, Color textColor) {
    return AppBarTheme(
      backgroundColor: bg,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.vazirmatn(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme(Color bg, Color selectedColor) {
    return BottomNavigationBarThemeData(
      backgroundColor: bg,
      selectedItemColor: selectedColor,
      unselectedItemColor: AppColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }
}