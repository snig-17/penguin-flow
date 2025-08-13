import 'package:flutter/material.dart';

/// Duolingo-inspired color palette for PenguinFlow
/// Features vibrant, engaging colors that promote productivity and joy
class AppColors {
  // Primary Colors - Inspired by Duolingo's green
  static const Color primary = Color(0xFF58CC02);      // Duolingo green
  static const Color primaryDark = Color(0xFF46A302);   // Darker green
  static const Color primaryLight = Color(0xFF6FE817);  // Lighter green

  // Secondary Colors - Vibrant and engaging
  static const Color secondary = Color(0xFF1CB0F6);     // Duolingo blue
  static const Color secondaryDark = Color(0xFF1493D4); // Darker blue
  static const Color accent = Color(0xFFFF9600);        // Orange accent

  // Background Colors
  static const Color background = Color(0xFFF7F7F7);    // Light gray
  static const Color backgroundDark = Color(0xFF131F24); // Dark mode bg
  static const Color surface = Color(0xFFFFFFFF);       // Card surface
  static const Color surfaceDark = Color(0xFF1E2A2F);   // Dark card surface

  // Text Colors
  static const Color textPrimary = Color(0xFF4B4B4B);   // Dark gray
  static const Color textSecondary = Color(0xFF777777); // Medium gray
  static const Color textLight = Color(0xFFAAAAAA);     // Light gray
  static const Color textWhite = Color(0xFFFFFFFF);     // White

  // Status Colors
  static const Color success = Color(0xFF58CC02);       // Success green
  static const Color warning = Color(0xFFFF9600);       // Warning orange
  static const Color error = Color(0xFFFF4B4B);         // Error red
  static const Color info = Color(0xFF1CB0F6);          // Info blue

  // Gamification Colors
  static const Color xpBar = Color(0xFF58CC02);         // XP progress
  static const Color streak = Color(0xFFFF6B35);        // Streak fire
  static const Color achievement = Color(0xFFFFD23F);   // Achievement gold
  static const Color level = Color(0xFF9C27B0);         // Level purple

  // Island Theme Colors
  static const Color water = Color(0xFF4FC3F7);         // Ocean blue
  static const Color sand = Color(0xFFFFE082);          // Beach sand
  static const Color grass = Color(0xFF66BB6A);         // Island grass
  static const Color snow = Color(0xFFE1F5FE);          // Snow effects

  // Social Colors
  static const Color online = Color(0xFF4CAF50);        // Online status
  static const Color offline = Color(0xFF9E9E9E);       // Offline status
  static const Color friend = Color(0xFF2196F3);        // Friend indicator

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF58CC02),
    Color(0xFF6FE817),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF1CB0F6),
    Color(0xFF42A5F5),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFF9600),
  ];

  static const List<Color> oceanGradient = [
    Color(0xFF4FC3F7),
    Color(0xFF29B6F6),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);   // Light shadow
  static const Color shadowMedium = Color(0x33000000);  // Medium shadow
  static const Color shadowDark = Color(0x4D000000);    // Dark shadow

  /// Get adaptive color based on brightness
  static Color adaptive(Color lightColor, Color darkColor, Brightness brightness) {
    return brightness == Brightness.light ? lightColor : darkColor;
  }

  /// Get theme-appropriate text color
  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.light ? textPrimary : textWhite;
  }

  /// Get theme-appropriate background color
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? background : backgroundDark;
  }

  /// Get theme-appropriate surface color
  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? surface : surfaceDark;
  }
}
