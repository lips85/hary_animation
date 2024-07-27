// lib/1_final_project/views/home_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hary_animation/1_final_project/const/text_style.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  bool isLoading = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(artworkListProvider.notifier).fetchArtworks();
    });
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  void preloadArtworkDetails(int startIndex) {
    final artworks = ref.read(artworkListProvider);
    for (var i = startIndex; i < startIndex + 20 && i < artworks.length; i++) {
      ref.read(artworkDetailFutureProvider(artworks[i].id).future);
    }
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _detailTap(int id) async {
    if (isLoading) return; // 클릭 방지
    setState(() {
      isLoading = true;
    });
    await ref.read(artworkDetailFutureProvider(id).future);
    setState(() {
      isLoading = false;
    });
    if (mounted) {
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: id,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artworks = ref.watch(artworkListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: artworks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  final currentIndex = _pageController.page?.round() ?? 0;
                  preloadArtworkDetails(currentIndex);
                }
                return false;
              },
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Container(
                      key: ValueKey(_currentPage),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7),
                            BlendMode.darken,
                          ),
                          image: NetworkImage(artworks[_currentPage].imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).animate().blur(
                        duration: const Duration(seconds: 1),
                      ),
                  PageView.builder(
                    controller: _pageController,
                    itemCount: artworks.length,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      preloadArtworkDetails(index);
                      _onPageChanged(index);
                    },
                    itemBuilder: (context, index) {
                      final artwork = artworks[index];
                      return GestureDetector(
                        onTap: () => _detailTap(artwork.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _scroll,
                                builder: (context, scroll, child) {
                                  final difference = (scroll - index).abs();
                                  final scale = 1 - (difference * 0.3);
                                  return Transform.scale(
                                    scale: scale,
                                    child: Column(
                                      children: [
                                        Hero(
                                          tag: 'artwork-${artwork.id}',
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child:
                                                Image.network(artwork.imageUrl)
                                                    .animate()
                                                    .fadeIn(duration: 600.ms),
                                          ),
                                        ),
                                        const Gap(30),
                                        Text(
                                          artwork.title,
                                          maxLines: 2,
                                          style: MyText().titleLarge(),
                                        ),
                                        const Gap(50),
                                        Text(
                                          artwork.artist,
                                          style: MyText().bodyLarge(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
