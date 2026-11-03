import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qurban App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const MainScreen(), // <--- UBAH KE MAIN SCREEN
    );
  }
}