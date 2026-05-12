// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/patrol_home_screen.dart';

void main() {
  runApp(const PatrolApp());
}

class PatrolApp extends StatelessWidget {
  const PatrolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Guard Patrol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blueGrey,
      ),
      home: const PatrolHomeScreen(),
    );
  }
}