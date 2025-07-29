import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: IconThemeData(
      size: 30,
      color: Colors.blue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.blue.shade100,
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: Colors.blue)
      ),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(color: Colors.blue)
      )
    )
    // Add more light theme customizations here
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
      iconTheme: IconThemeData(
        size: 30,
        color: Colors.deepPurple,
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.deepPurple,
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: Colors.white)
      ),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(color: Colors.white)
      )
    )
    // Add more dark theme customizations here
  );
}
