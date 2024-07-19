import 'package:flutter/material.dart';
import 'package:hary_animation/features/01_implicit_animations/implicit_animations_screen.dart';

import 'package:hary_animation/features/02_explicit_animation/explicit_animation_screen.dart';

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
          ],
        ),
      ),
    );
  }
}
