import 'package:flutter/material.dart';
import 'package:hary_animation/0_challenges/features/00_menu_screen.dart/menu_screen.dart';
import 'package:hary_animation/0_challenges/features/04_swiping_card/swiping_card_screen.dart';

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
      ),
      home: const SwipingCard2sScreen(),
    );
  }
}
