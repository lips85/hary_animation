import 'package:flutter/material.dart';
import 'package:hary_animation/0_challenges/features/01_implicit_animations/implicit_animations_screen.dart';

import 'package:hary_animation/0_challenges/features/02_explicit_animation/explicit_animation_screen.dart';
import 'package:hary_animation/0_challenges/features/03_custom_painter/custom_painter.dart';
import 'package:hary_animation/0_challenges/features/03_custom_painter/custon2.dart';

import 'package:hary_animation/0_challenges/features/04_swiping_card/swiping_card_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animation'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  _goToPage(context, const ImplicitAnimationsScreen()),
              child: const Text(
                "Implicit Animations",
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  _goToPage(context, const ExplicitAnimationScreen()),
              child: const Text(
                "Explicit Animations",
              ),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const CustomPainterScreen()),
              child: const Text(
                "Custom Painter",
              ),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const CustomPainter2Screen()),
              child: const Text(
                "Custom Painter2",
              ),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(context, const SwipingCard2sScreen()),
              child: const Text(
                "Swiping Card",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
