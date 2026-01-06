import 'package:campus_thrift/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CampusThriftApp());
}

class CampusThriftApp extends StatefulWidget {
  const CampusThriftApp({super.key});

  @override
  State<CampusThriftApp> createState() => _CampusThriftAppState();
}

class _CampusThriftAppState extends State<CampusThriftApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusThrift',
      themeMode: _themeMode,

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.orange,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 1,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.orange,
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey.shade800,
          elevation: 2,
        ),
      ),

      home: HomeScreen(onThemeChanged: _toggleTheme),

      routes: {
        '/home': (context) => HomeScreen(onThemeChanged: _toggleTheme),
      },
    );
  }
}
