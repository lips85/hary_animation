// lib/1_final_project/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/views/artwork_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

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
    final double containerHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Institute of Chicago'),
      ),
      body: artworks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: artworks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final artwork = artworks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArtworkDetailScreen(artworkId: artwork.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'artwork-${artwork.id}',
                              child: Container(
                                height: containerHeight,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: artwork.imageUrl.isNotEmpty
                                        ? NetworkImage(artwork.imageUrl)
                                        : const AssetImage(
                                            'assets/placeholder.jpg'),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(30),
                            Text(
                              artwork.title,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const Gap(10),
                            Text(
                              artwork.artist,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
