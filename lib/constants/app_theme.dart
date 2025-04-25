import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Culori
  static const Color primaryGreen    = Color(0xFF2E7D32);
  static const Color lightGreen      = Color(0xFF81C784);
  static const Color accentGreen     = Color(0xFF00C853);
  static const Color earthBrown      = Color(0xFF795548);
  static const Color skyBlue         = Color(0xFF4FC3F7);
  static const Color creamBackground = Color(0xFFF5F5F5);
  static const Color textDark        = Color(0xFF263238);
  static const Color textLight       = Color(0xFFECEFF1);

  // --- TEXT STYLES cu fallback complet ---
  static TextStyle get headingStyle => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textDark,
      ).copyWith(
        fontFamilyFallback: const ['Noto Sans', 'Roboto', 'sans-serif'],
      );

  static TextStyle get subheadingStyle => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ).copyWith(
        fontFamilyFallback: const ['Noto Sans', 'Roboto', 'sans-serif'],
      );

  static TextStyle get bodyStyle => GoogleFonts.lato(
        fontSize: 16,
        color: textDark,
      ).copyWith(
        fontFamilyFallback: const ['Noto Sans', 'Roboto', 'sans-serif'],
      );

  static TextStyle get captionStyle => GoogleFonts.lato(
        fontSize: 14,
        color: Colors.grey[700],
        fontStyle: FontStyle.italic,
      ).copyWith(
        fontFamilyFallback: const ['Noto Sans', 'Roboto', 'sans-serif'],
      );

  // --- THEME DATA ---
  static ThemeData get lightTheme => ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: creamBackground,
        colorScheme: const ColorScheme.light(
          primary: primaryGreen,
          secondary: accentGreen,
          surface: Colors.white,
          background: creamBackground,
          error: Colors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: textLight,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentGreen,
            foregroundColor: textLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryGreen),
        ),
        iconTheme: const IconThemeData(color: primaryGreen),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: lightGreen.withOpacity(0.5),
          thickness: 1,
        ),
      );
}
