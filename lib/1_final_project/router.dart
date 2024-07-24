// lib/1_final_project/router.dart
import 'package:flutter/material.dart';
import 'package:hary_animation/1_final_project/views/home_screen.dart';
import 'package:hary_animation/1_final_project/views/artwork_detail_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/detail':
        final int id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ArtworkDetailScreen(artworkId: id),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
