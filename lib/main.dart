import 'package:flutter/material.dart';
import 'package:todo/screens/WelcomeScreens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreens(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF5FF), // Mengubah tema menjadi terang
      ),
    );
  }
}