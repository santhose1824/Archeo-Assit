import 'package:flutter/material.dart';

class ColorManager {
  // Define your background colors
  static const Color primaryBackgroundColor = Color(0xFFD3C862);
  static const Color GridColor = Color(0xFF112A46);

  // Define your text colors
  static const Color primaryTextColor = Colors.white;
  static const Color AppTextColor = Color(0xFF112A46);
  static const Color HeadingsColors = Color(0xFF650327);

  // Add more colors as needed

  // Example method to get a BoxDecoration with a specific background color
  static BoxDecoration getBoxDecorationWithBackground() {
    return BoxDecoration(
      color: primaryBackgroundColor,
      // Add other decoration properties as needed
    );
  }

  // Example method to get a TextStyle with a specific text color
  static TextStyle getTextStyleWithColor() {
    return TextStyle(
      color: primaryTextColor,
      // Add other text style properties as needed
    );
  }
}
