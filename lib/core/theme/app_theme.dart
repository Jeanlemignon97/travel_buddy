import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Classe utilitaire pour définir le thème visuel de l'application.
///
/// Propose une palette 'Travel' avec des tons Bleu Océan et Orange Sable,
/// optimisée pour Material 3.
class AppTheme {
  // Couleurs principales (Bleu Océan et Orange Sable)
  static const Color oceanBlue = Color(0xFF0077B6);
  static const Color sandOrange = Color(0xFFF4A261);
  static const Color deepSea = Color(0xFF023E8A);
  static const Color lightSand = Color(0xFFE9C46A);

  /// Retourne le [ThemeData] configuré pour l'application.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oceanBlue,
        primary: oceanBlue,
        secondary: sandOrange,
        surface: const Color(0xFFFAFAFA),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      
      // Configuration de la typographie (via Google Fonts)
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),

      // Thème des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oceanBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Thème des cartes
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.withAlpha(51), // ~0.2 opacity
            width: 1,
          ),
        ),
        color: Colors.white,
      ),

      // Thème de l'AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          color: oceanBlue,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        iconTheme: const IconThemeData(color: oceanBlue),
      ),

      // Thème du FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: sandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
