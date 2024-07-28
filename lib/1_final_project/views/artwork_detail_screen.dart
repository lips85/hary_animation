// lib/1_final_project/views/artwork_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';

class ArtworkDetailScreen extends ConsumerWidget {
  final int artworkId;

  const ArtworkDetailScreen({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkDetail = ref.watch(artworkDetailFutureProvider(artworkId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: artworkDetail.when(
        data: (artwork) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Artist: ${artwork.artistTitle}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Failed to load artwork details: $err')),
      ),
    );
  }
}
