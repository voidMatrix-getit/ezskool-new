import 'package:flutter/material.dart';

// Helper class to manage screen sizes
class ScreenUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;
  static late double textScaleFactor;

  // Initialize in your main screen
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100; // 1% of screen width
    blockHeight = screenHeight / 100; // 1% of screen height
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  // Convert pixels to responsive size (works for both width and height)
  static double adaptive(double pixels) {
    // If width is greater than height, use width as reference
    // This ensures consistent scaling regardless of orientation
    double referenceSize = screenWidth > screenHeight ? screenWidth : screenHeight;
    return (pixels / referenceSize) * 100;
  }

  // Get size based on pixel value
  static double getSize(double pixels) {
    double percentage = adaptive(pixels);
    return (screenWidth > screenHeight ? screenWidth : screenHeight) * (percentage / 100);
  }

  // Get responsive size based on screen width
  static double getResponsiveWidth(double percentage) {
    return blockWidth * percentage;
  }

  // Get responsive size based on screen height
  static double getResponsiveHeight(double percentage) {
    return blockHeight * percentage;
  }

  // Get responsive font size
  static double getResponsiveFont(double size) {
    return (size / textScaleFactor);
  }
}
