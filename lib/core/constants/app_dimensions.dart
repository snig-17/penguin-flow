/// Dimension constants for consistent spacing and sizing
/// Following Material Design guidelines with custom additions
class AppDimensions {
  // Spacing Constants
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Margin Constants (same as padding for consistency)
  static const double marginTiny = paddingTiny;
  static const double marginSmall = paddingSmall;
  static const double marginMedium = paddingMedium;
  static const double marginLarge = paddingLarge;
  static const double marginXL = paddingXL;
  static const double marginXXL = paddingXXL;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  // Button Dimensions
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 64.0;
  static const double buttonMinWidth = 120.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Avatar Sizes
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 56.0;
  static const double avatarLarge = 80.0;
  static const double avatarXL = 120.0;

  // Card Dimensions
  static const double cardElevation = 4.0;
  static const double cardElevationHovered = 8.0;
  static const double cardMaxWidth = 400.0;

  // Progress Indicators
  static const double progressBarHeight = 8.0;
  static const double progressRingStrokeWidth = 8.0;
  static const double progressRingSize = 200.0;

  // Timer Specific
  static const double timerSize = 280.0;
  static const double timerStrokeWidth = 12.0;

  // Island Canvas
  static const double islandCanvasHeight = 400.0;
  static const double islandCanvasMinHeight = 300.0;

  // Bottom Navigation
  static const double bottomNavHeight = 80.0;
  static const double bottomNavIconSize = 28.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // List Items
  static const double listItemHeight = 72.0;
  static const double listItemMinHeight = 56.0;

  // Floating Action Button
  static const double fabSize = 56.0;
  static const double fabMiniSize = 40.0;

  // Animation Durations (in milliseconds)
  static const int animationFast = 200;
  static const int animationMedium = 300;
  static const int animationSlow = 500;
  static const int animationXSlow = 800;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Responsive padding based on screen width
  static double getResponsivePadding(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return paddingMedium;
    } else if (screenWidth < tabletBreakpoint) {
      return paddingLarge;
    } else {
      return paddingXL;
    }
  }

  // Get responsive font size
  static double getResponsiveFontSize(double baseSize, double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return baseSize;
    } else if (screenWidth < tabletBreakpoint) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }
}
