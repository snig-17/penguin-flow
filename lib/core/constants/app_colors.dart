import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette (Duolingo-inspired)
  static const primary = Color(0xFF58CC02);
  static const primaryDark = Color(0xFF46A302);
  static const primaryLight = Color(0xFF89E219);

  // Secondary
  static const secondary = Color(0xFF1CB0F6);
  static const secondaryDark = Color(0xFF1899D6);
  static const secondaryLight = Color(0xFF84D8FF);

  // Accent
  static const accent = Color(0xFFFF9600);
  static const accentDark = Color(0xFFE88700);
  static const accentLight = Color(0xFFFFBF60);

  // Status
  static const success = Color(0xFF58CC02);
  static const warning = Color(0xFFFFC800);
  static const error = Color(0xFFFF4B4B);
  static const info = Color(0xFF1CB0F6);

  // Neutrals
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF7F7F7);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFE8E8E8);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E5E5);
  static const textPrimary = Color(0xFF3C3C3C);
  static const textSecondary = Color(0xFF777777);
  static const textHint = Color(0xFFAFAFAF);
  static const dark = Color(0xFF1A1A2E);

  // Dark mode
  static const darkBackground = Color(0xFF131324);
  static const darkSurface = Color(0xFF1E1E3A);
  static const darkCard = Color(0xFF252547);
  static const darkBorder = Color(0xFF3A3A5C);

  // Island themes
  static const tropicalSand = Color(0xFFF5DEB3);
  static const tropicalWater = Color(0xFF00CED1);
  static const arcticIce = Color(0xFFE0F7FA);
  static const arcticWater = Color(0xFF4FC3F7);
  static const volcanicRock = Color(0xFF5D4037);
  static const volcanicLava = Color(0xFFFF5722);
  static const forestGreen = Color(0xFF2E7D32);
  static const forestGround = Color(0xFF8D6E63);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF9600), Color(0xFFFFC800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const oceanGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
