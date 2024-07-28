// lib/1_final_project/views/artwork_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hary_animation/1_final_project/const/text_style.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';

class ArtworkDetailScreen extends ConsumerStatefulWidget {
  final int artworkId;

  const ArtworkDetailScreen({super.key, required this.artworkId});

  @override
  ConsumerState<ArtworkDetailScreen> createState() =>
      _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends ConsumerState<ArtworkDetailScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final artworkDetail =
        ref.watch(artworkDetailFutureProvider(widget.artworkId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: artworkDetail.when(
        data: (artwork) => GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              Navigator.of(context).pop();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(100),
                Text(
                  'Artwork Details',
                  style: MyText().titleLarge().copyWith(
                        fontSize: 35,
                      ),
                ).animate().shimmer(
                  duration: const Duration(seconds: 2),
                  colors: [
                    Colors.white,
                    Colors.black,
                    Colors.white,
                    Colors.black,
                    Colors.white
                  ],
                ),
                const Gap(50),
                Hero(
                  tag: 'artwork-${artwork.id}',
                  child: artwork.imageUrl.isNotEmpty
                      ? Image.network(
                          artwork.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 300,
                              color: Colors.grey,
                              child: const Center(
                                child: Text(
                                  'Image not available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey,
                          child: const Center(
                            child: Text(
                              'Image not available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.title,
                        style: MyText().titleLarge(),
                      ),
                      const Gap(8),
                      Text(
                        'Artist: ${artwork.artistTitle}',
                        style: MyText().bodyLarge(),
                      ),
                      const Gap(8),
                      Text(
                        'Date: ${artwork.date}',
                        style: MyText().bodyLarge(),
                      ),
                      const Gap(8),
                      Text(
                        'Medium: ${artwork.medium}',
                        style: MyText().bodyLarge(),
                      ),
                      const Gap(8),
                      Html(
                        data: artwork.description,
                        style: {
                          "body": Style(
                            fontSize: FontSize(16),
                            color: Colors.grey,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Failed to load artwork details: $err')),
      ),
    );
  }
}
