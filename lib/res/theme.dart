import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 193, 160, 236),
        surface: const Color.fromARGB(255, 193, 160, 236),
        background: const Color(0xFFFFECFF),
      ),
      // colorSchemeSeed: const Color.fromARGB(255, 193, 160, 236),
      // canvasColor: const Color(0xFFF8EEF8),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 40, color: Colors.white),
        titleSmall: TextStyle(fontSize: 28, color: Colors.white, height: 1),
      ),

      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 24,
        ),
      )
    );
  }
}
