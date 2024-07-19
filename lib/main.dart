import 'package:flutter/material.dart';
import 'package:hary_animation/features/00_menu_screen.dart/menu_screen.dart';
import 'package:hary_animation/features/03_custom_painter/custom_painter.dart';

void main() {
  runApp(const HaryAnimation());
}

class HaryAnimation extends StatelessWidget {
  const HaryAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation MasterClass',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.grey,
      ),
      home: const CustomPainterScreen(),
    );
  }
}
