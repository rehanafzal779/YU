import 'package:flutter/material.dart';

/// EmployeeResponsiveData - Contains all responsive calculations for employee screens
class EmployeeResponsiveData {
  final double screenWidth;
  final double screenHeight;
  final double safePaddingTop;
  final double safePaddingBottom;

  EmployeeResponsiveData({
    required this.screenWidth,
    required this. screenHeight,
    required this.safePaddingTop,
    required this.safePaddingBottom,
  });

  // Enhanced screen size checks
  bool get isMicroScreen => screenWidth < 100;
  bool get isTinyScreen => screenWidth >= 100 && screenWidth < 200;
  bool get isVerySmallScreen => screenWidth >= 200 && screenWidth < 360;
  bool get isSmallScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1024;
  bool get isLargeScreen => screenWidth >= 1024;
  bool get isLandscape => screenWidth > screenHeight;

  // Legacy compatibility
  bool get isNanoScreen => isTinyScreen || isVerySmallScreen;
  bool get isMiniScreen => isSmallScreen;

  // Content visibility helpers
  bool get showSecondaryText => ! isMicroScreen && !isTinyScreen;
  bool get showDetailedContent => !isMicroScreen && !isTinyScreen;
  bool get showIcons => !isMicroScreen;
  bool get showShadows => !isMicroScreen && !isTinyScreen;
  bool get showTrends => !isMicroScreen && !isTinyScreen;

  // Padding values
  double get padding {
    if (isMicroScreen) return 4.0;
    if (isTinyScreen) return 6.0;
    if (isVerySmallScreen) return 8.0;
    if (isSmallScreen) return 12.0;
    if (isMediumScreen) return 16.0;
    return 24.0;
  }

  double get microPadding => padding * 0.5;
  double get nanoPadding => padding * 0.25;
  double get largePadding => padding * 1.5;

  // Font scale
  double get fontScale {
    if (isMicroScreen) return 0.5;
    if (isTinyScreen) return 0.65;
    if (isVerySmallScreen) return 0.75;
    if (isSmallScreen) return 0.85;
    if (isMediumScreen) return 1.0;
    return 1.2;
  }

  // Font size calculator
  double fontSize(double baseSize) {
    return baseSize * fontScale;
  }

  // Dimension calculator
  double dimension(double baseSize) {
    if (isMicroScreen) return baseSize * 0.4;
    if (isTinyScreen) return baseSize * 0.55;
    if (isVerySmallScreen) return baseSize * 0.7;
    if (isSmallScreen) return baseSize * 0.85;
    if (isMediumScreen) return baseSize * 0.95;
    return baseSize;
  }

  // Icon size calculator
  double iconSize(double baseSize) {
    if (isMicroScreen) return baseSize * 0.6;
    if (isTinyScreen) return baseSize * 0.7;
    if (isVerySmallScreen) return baseSize * 0.8;
    return baseSize;
  }

  // Grid columns
  int get gridColumns {
    if (isMicroScreen) return 1;
    if (isTinyScreen) return 1;
    if (isVerySmallScreen) return 1;
    if (isSmallScreen) return 2;
    if (isMediumScreen) return 3;
    return 4;
  }

  // Card aspect ratio
  double get cardAspectRatio {
    if (isMicroScreen) return 1.5;
    if (isTinyScreen) return 1.8;
    if (isVerySmallScreen) return 2.0;
    if (isSmallScreen) return 1.2;
    return 1.0;
  }

  // Border radius
  double get borderRadius {
    if (isMicroScreen) return 6.0;
    if (isTinyScreen) return 8.0;
    if (isVerySmallScreen) return 10.0;
    return 12.0;
  }

  double get largeBorderRadius => borderRadius * 1.5;

  // Adaptive text helper
  String adaptiveText(String full, {String? micro, String?  nano, String? mini, String? tiny}) {
    if (isMicroScreen && micro != null) return micro;
    if (isTinyScreen && (tiny ??  nano) != null) return tiny ?? nano! ;
    if (isVerySmallScreen && nano != null) return nano;
    if (isSmallScreen && mini != null) return mini;
    return full;
  }

  // Chart height
  double get chartHeight {
    if (isMicroScreen) return 100;
    if (isTinyScreen) return 120;
    if (isVerySmallScreen) return 150;
    if (isSmallScreen) return 200;
    return 250;
  }

  // Max content width
  double get maxContentWidth {
    if (isLargeScreen) return 1200;
    if (isMediumScreen) return 900;
    return screenWidth;
  }
}

/// EmployeeResponsiveHelper Widget
class EmployeeResponsiveHelper extends StatelessWidget {
  final Widget Function(BuildContext context, EmployeeResponsiveData responsive) builder;

  const EmployeeResponsiveHelper({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery. of(context);

    final responsive = EmployeeResponsiveData(
      screenWidth: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
      safePaddingTop: mediaQuery.padding.top,
      safePaddingBottom: mediaQuery.padding.bottom,
    );

    return builder(context, responsive);
  }
}