// lib/1_final_project/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/views/artwork_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(artworkListProvider.notifier).fetchArtworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final artworks = ref.watch(artworkListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Institute of Chicago'),
      ),
      body: artworks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                final artwork = artworks[index];
                return ListTile(
                  leading: artwork.imageUrl.isNotEmpty
                      ? Image.network(artwork.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                          child: const Icon(Icons.image, color: Colors.white)),
                  title: Text(artwork.title),
                  subtitle: Text(artwork.artist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArtworkDetailScreen(artworkId: artwork.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
