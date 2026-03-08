import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepOcean,
      primaryColor: AppColors.bioTeal,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.bioTeal,
        secondary: AppColors.seaFoam,
        surface: AppColors.abyssBlue,
        error: AppColors.warningOrange,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.bioTeal,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.shareTechMono(
          fontSize: 16,
          color: AppColors.chromeSilver,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.chromeSilver,
        ),
        labelLarge: GoogleFonts.shareTechMono(
          fontSize: 14,
          color: AppColors.bioTeal,
          letterSpacing: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.abyssBlue,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.bioTeal,
          letterSpacing: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.abyssBlue, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bioTeal,
          foregroundColor: AppColors.deepOcean,
          textStyle: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
