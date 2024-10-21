import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenHeight;
  static late double screenWidth;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    orientation = _mediaQueryData.orientation;
  }
}

/// Get the propotional height of [inputHeight] to the screen size
double getHeight(double inputHeight) {
  final screenHeight = SizeConfig.screenHeight;

  // 844 is the screen height used by the designer
  return (inputHeight / 844.0) * screenHeight;
}

/// Get the propotional width of [inputWidth] to the screen size
double getWidth(double inputWidth) {
  final screenWidth = SizeConfig.screenWidth;

  // 390 is the screen width used by the designer
  return (inputWidth / 390.0) * screenWidth;
}
