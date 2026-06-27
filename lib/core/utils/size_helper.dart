import 'package:flutter/material.dart';

class SizeHelper {
  SizeHelper._();

  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static double wp(BuildContext context, double percent) =>
      width(context) * percent / 100;

  static double hp(BuildContext context, double percent) =>
      height(context) * percent / 100;

  /// Returns true if the screen width is >= 600 logical pixels (tablet breakpoint).
  static bool isTablet(BuildContext context) => width(context) >= 600;

  /// Returns the number of grid columns based on screen width.
  /// Phone: 2 columns, Tablet: 3 columns, Large tablet: 4 columns.
  static int gridColumns(BuildContext context) {
    final w = width(context);
    if (w >= 900) return 4;
    if (w >= 600) return 3;
    return 2;
  }

  /// Adaptive horizontal padding for screen edges.
  /// Phone: 16px, Tablet: 32px.
  static double horizontalPadding(BuildContext context) =>
      isTablet(context) ? 32.0 : 16.0;
}
