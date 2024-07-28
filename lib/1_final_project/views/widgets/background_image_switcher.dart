// lib/1_final_project/widgets/background_image_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BackgroundImageSwitcher extends StatelessWidget {
  const BackgroundImageSwitcher({
    super.key,
    required this.artworks,
    required this.currentPage,
  });

  final List artworks;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: Container(
        key: ValueKey(currentPage),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
            image: NetworkImage(
              artworks[currentPage].imageUrl.isNotEmpty
                  ? artworks[currentPage].imageUrl
                  : 'https://via.placeholder.com/800',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ).animate().blur(
          duration: const Duration(seconds: 1),
        );
  }
}
