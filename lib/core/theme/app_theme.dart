import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color lightGrey = Color(0xFFB3B3B3);

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: black,
        primaryColor: white,
        colorScheme: const ColorScheme.dark(
          primary: white,
          onPrimary: black,
          surface: darkGrey,
          onSurface: white,
          background: black,
          onBackground: white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: white,
          displayColor: white,
        ),
        iconTheme: const IconThemeData(
          color: white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
        ));
  }
}
