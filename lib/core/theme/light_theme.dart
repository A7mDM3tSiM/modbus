import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xff2c8769),
    onPrimary: Colors.white,
    secondary: const Color(0xff6699cc),
    onSecondary: Colors.white,
    error: Colors.red.shade500,
    onError: Colors.white,
    surface: const Color(0xffffffff),
    onSurface: Colors.black,
  ),
);
