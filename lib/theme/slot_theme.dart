import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlotTheme {
  static const Color bgOuter = Color(0xFF1A1A2E);
  static const Color bgInner = Color(0xFF3C3C5C);
  static const Color frameDark = Color(0xFF2D3748);
  static const Color frameLight = Color(0xFF4A5568);
  static const Color goldLight = Color(0xFFFEF08A);
  static const Color goldDark = Color(0xFFCA8A04);
  static const Color creditGreen = Color(0xFF4ADE80);
  static const Color displayBg = Color(0xCC000000);
  static const Color slotBg = Color(0xFF374151);
  static const Color slotBorder = Color(0xFF1F2937);
  static const Color betBlue = Color(0xFF1D4ED8);
  static const Color betBlueLight = Color(0xFF60A5FA);
  static const Color betBlueShadow = Color(0xFF1E3A8A);
  static const Color betSelected = Color(0xFFF59E0B);
  static const Color betSelectedShadow = Color(0xFFB45309);
  static const Color cashoutYellow = Color(0xFFEAB308);
  static const Color cashoutYellowShadow = Color(0xFFB45309);
  static const Color playGreen = Color(0xFF16A34A);
  static const Color playGreenShadow = Color(0xFF15803D);
  static const Color doublePurple = Color(0xFF9333EA);
  static const Color doublePurpleShadow = Color(0xFF581C87);
  static const Color winnerGreen = Color(0xFF22C55E);
  static const Color loserRed = Color(0xFFF87171);

  static TextStyle gameFont({
    double size = 16,
    Color color = Colors.white,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: size,
      color: color,
      height: 1.15,
      shadows: shadows,
    );
  }

  static TextStyle bodyFont({
    double size = 14,
    Color color = Colors.white,
    FontWeight weight = FontWeight.bold,
  }) {
    return GoogleFonts.robotoCondensed(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: 1.0,
    );
  }

  static const RadialGradient backgroundGradient = RadialGradient(
    colors: [bgInner, bgOuter],
    radius: 1.1,
  );

  static const LinearGradient frameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [frameLight, frameDark],
  );

  static const LinearGradient goldBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, goldDark, goldLight],
  );
}
