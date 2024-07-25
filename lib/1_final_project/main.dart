// lib/1_final_project/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/views/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: HaryFinalAnimation()));
}

class HaryFinalAnimation extends StatelessWidget {
  const HaryFinalAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Institute of Chicago',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
