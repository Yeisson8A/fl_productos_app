import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.deepPurple; 
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background del Scaffold
    scaffoldBackgroundColor: Colors.grey[300],
    // Tema del AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: primary,
      centerTitle: true, 
      titleTextStyle: TextStyle(fontSize: 20, color: Colors.white)
    ),
    // Tema del FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      shape: CircleBorder()
    )
  );
}