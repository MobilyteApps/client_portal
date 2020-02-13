import 'package:flutter/material.dart';

class Brand {
  static const int _mainPrimary = 0xff002841;

  static const MaterialColor primary = MaterialColor(
    _mainPrimary,
    <int, Color>{
      50: Color(0xff738997),
      100: Color(0xff5C7686),
      200: Color(0xff456274),
      300: Color(0xff2E4F63),
      400: Color(0xff173B52),
      500: Color(_mainPrimary),
      600: Color(0xff00253C),
      700: Color(0xff002136),
      800: Color(0xff001E30),
      900: Color(0xff001A2A),
    },
  );
}
