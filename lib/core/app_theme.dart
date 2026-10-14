import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlEuroColors {
  static const Color black = Color(0xFF000000);      // Deep surfaces & dark AppBar
  static const Color charcoal = Color(0xFF333231);   // Main dark background
  static const Color darkGray = Color(0xFF5A5754);   // Cards, borders, secondary surfaces
  static const Color warmGray = Color(0xFF9A9690);   // Secondary text, icons, dividers
  static const Color burgundy = Color(0xFF5C0E0E);   // Primary accent ONLY for key CTAs/badges/chips/prices
  static const Color ivory = Color(0xFFF0EDE6);      // Primary text on dark, light-mode background
}

class AlEuroTheme {
  static TextTheme _buildTextTheme(TextTheme base, String langCode, Color primaryTextColor, Color secondaryTextColor) {
    final isAr = langCode == 'ar';
    return base.copyWith(
      displayLarge: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: primaryTextColor,
        fontWeight: FontWeight.w800,
        letterSpacing: isAr ? 0 : 1.5,
      ),
      titleLarge: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: primaryTextColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        letterSpacing: isAr ? 0 : 1.1,
      ),
      titleMedium: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: primaryTextColor,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: isAr ? 0 : 0.6,
      ),
      bodyLarge: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: primaryTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      bodyMedium: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
      labelLarge: (isAr ? GoogleFonts.tajawal : GoogleFonts.montserrat)(
        color: AlEuroColors.ivory,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: isAr ? 0 : 0.8,
      ),
    );
  }

  static ThemeData darkTheme(String langCode) {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AlEuroColors.charcoal,
      primaryColor: AlEuroColors.burgundy,
      colorScheme: const ColorScheme.dark(
        primary: AlEuroColors.burgundy,
        secondary: AlEuroColors.warmGray,
        surface: AlEuroColors.black,
        onPrimary: AlEuroColors.ivory,
        onSurface: AlEuroColors.ivory,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AlEuroColors.black,
        foregroundColor: AlEuroColors.ivory,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AlEuroColors.black,
        elevation: 3,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AlEuroColors.darkGray, width: 0.8),
        ),
      ),
      dividerColor: AlEuroColors.warmGray.withOpacity(0.25),
      textTheme: _buildTextTheme(base.textTheme, langCode, AlEuroColors.ivory, AlEuroColors.warmGray),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AlEuroColors.burgundy,
          foregroundColor: AlEuroColors.ivory,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AlEuroColors.ivory,
          side: const BorderSide(color: AlEuroColors.darkGray, width: 1.2),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AlEuroColors.black,
        hintStyle: const TextStyle(color: AlEuroColors.warmGray, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlEuroColors.darkGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlEuroColors.burgundy, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData lightTheme(String langCode) {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AlEuroColors.ivory,
      primaryColor: AlEuroColors.burgundy,
      colorScheme: const ColorScheme.light(
        primary: AlEuroColors.burgundy,
        secondary: AlEuroColors.darkGray,
        surface: Colors.white,
        onPrimary: AlEuroColors.ivory,
        onSurface: AlEuroColors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AlEuroColors.ivory,
        foregroundColor: AlEuroColors.black,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AlEuroColors.warmGray.withOpacity(0.4), width: 0.8),
        ),
      ),
      dividerColor: AlEuroColors.warmGray.withOpacity(0.35),
      textTheme: _buildTextTheme(base.textTheme, langCode, AlEuroColors.black, AlEuroColors.darkGray),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AlEuroColors.burgundy,
          foregroundColor: AlEuroColors.ivory,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AlEuroColors.warmGray, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AlEuroColors.warmGray.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlEuroColors.burgundy, width: 1.5),
        ),
      ),
    );
  }
}
