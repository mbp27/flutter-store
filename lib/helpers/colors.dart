import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor pallete =
      MaterialColor(_palletePrimaryValue, <int, Color>{
    50: Color(0xFFE0ECFD),
    100: Color(0xFFB3CFFA),
    200: Color(0xFF80AFF7),
    300: Color(0xFF4D8EF4),
    400: Color(0xFF2676F1),
    500: Color(_palletePrimaryValue),
    600: Color(0xFF0056ED),
    700: Color(0xFF004CEB),
    800: Color(0xFF0042E8),
    900: Color(0xFF0031E4),
  });
  static const int _palletePrimaryValue = 0xFF005EEF;

  static const MaterialColor palleteAccent =
      MaterialColor(_palleteAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_palleteAccentValue),
    400: Color(0xFFA5B3FF),
    700: Color(0xFF8B9DFF),
  });
  static const int _palleteAccentValue = 0xFFD8DEFF;
}
