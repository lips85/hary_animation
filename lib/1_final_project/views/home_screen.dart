import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hary_animation/1_final_project/const/text_style.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/views/artwork_detail_screen.dart';
import 'package:hary_animation/1_final_project/views/widgets/background_image_switcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  bool isLoading = false;
  int _currentPage = 0;
  bool _showDetailScreen = false;

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
    setState(() {
      preloadArtworkDetails(_currentPage);
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

  @override
  void dispose() {
    _pageController.dispose();
    _topPageController.dispose();
    super.dispose();
  }

  late final AnimationController _topPageController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  final Curve _menuCurve = Curves.easeInOutBack;

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: const Offset(0, 0.9),
  ).animate(
    CurvedAnimation(
      parent: _topPageController,
      curve: Interval(
        0.0,
        1.0,
        curve: _menuCurve,
      ),
    ),
  );

  void _openMenu() {
    _topPageController.forward();
    setState(() {
      _showDetailScreen = true;
    });
  }

  void _closeMenu() {
    _topPageController.reverse().whenComplete(() {
      setState(() {
        _showDetailScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final artworks = ref.watch(artworkListProvider);

    return artworks.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              BackgroundImageSwitcher(
                artworks: artworks,
                currentPage: _currentPage,
              ),
              if (_showDetailScreen)
                GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      _closeMenu();
                    }
                  },
                  child: ArtworkDetailScreen(
                    artworkId: artworks[_currentPage].id,
                  ),
                ),
              SlideTransition(
                position: _screenOffset,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        final currentIndex = _pageController.page?.round() ?? 0;
                        preloadArtworkDetails(currentIndex);
                      }
                      return false;
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        BackgroundImageSwitcher(
                          artworks: artworks,
                          currentPage: _currentPage,
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                    blurRadius: 10,
                                                    spreadRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              child: artwork.imageUrl.isNotEmpty
                                                  ? Image.network(
                                                      artwork.imageUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          width: 400,
                                                          height: 400,
                                                          color: Colors.white,
                                                          child: const Center(
                                                            child: Text(
                                                              'Image not available',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Container(
                                                      width: 400,
                                                      height: 400,
                                                      color: Colors.white,
                                                      child: const Center(
                                                        child: Text(
                                                          'Image not available',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            const Gap(30),
                                            Text(
                                              artwork.title,
                                              maxLines: 1,
                                              style: MyText().titleLarge(),
                                            ),
                                            const Gap(50),
                                            Text(
                                              artwork.artistTitle,
                                              style: MyText().bodyLarge(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: _showDetailScreen ? 0 : 50,
                          child: IconButton(
                            iconSize: 50,
                            onPressed:
                                _showDetailScreen ? _closeMenu : _openMenu,
                            icon: _showDetailScreen
                                ? const Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: Colors.yellow,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.yellow,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
