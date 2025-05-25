import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF10A37F);
  static const _backgroundColor = Color(0xFFFFFFFF);
  static const _darkBackgroundColor = Color(0xFF343541);
  static const _textColor = Color(0xFF202123);
  static const _darkTextColor = Color(0xFFFFFFFF);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      background: _backgroundColor,
      onBackground: _textColor,
    ),
    scaffoldBackgroundColor: _backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _textColor),
      titleTextStyle: TextStyle(
        color: _textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _textColor),
      bodyMedium: TextStyle(color: _textColor),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      background: _darkBackgroundColor,
      onBackground: _darkTextColor,
    ),
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkTextColor),
      titleTextStyle: TextStyle(
        color: _darkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _darkTextColor),
      bodyMedium: TextStyle(color: _darkTextColor),
    ),
  );
} 