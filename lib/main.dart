// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CampusThriftApp());
}

class CampusThriftApp extends StatelessWidget {
  const CampusThriftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusThrift',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
