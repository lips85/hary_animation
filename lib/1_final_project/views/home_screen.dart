import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hary_animation/1_final_project/const/text_style.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/views/widgets/background_image_switcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';

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
    duration: const Duration(milliseconds: 1500),
  );

  final Curve _menuCurve = Curves.easeIn;

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: const Offset(0, 0.85),
  ).animate(
    CurvedAnimation(
      parent: _topPageController,
      curve: _menuCurve,
    ),
  );

  late final AnimationController _opacityControllor = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  void _openMenu() async {
    await _topPageController.forward();
    _opacityControllor.forward();
    setState(() {
      _showDetailScreen = true;
    });
  }

  void _closeMenu() async {
    await _topPageController.reverse();
    _opacityControllor.reverse();
    setState(() {
      _showDetailScreen = false;
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
              AnimatedOpacity(
                opacity: _showDetailScreen ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInCirc,
                child: ArtworkDetailScreen(
                  artworkId: artworks[_currentPage].id,
                ),
              ).animate().fadeIn(),
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
                        _showDetailScreen
                            ? Container(
                                color: Colors.black,
                              )
                            : BackgroundImageSwitcher(
                                artworks: artworks,
                                currentPage: _currentPage,
                              ),
                        GestureDetector(
                          onVerticalDragEnd: (context) => _openMenu(),
                          child: PageView.builder(
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
                                        final difference =
                                            (scroll - index).abs();
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
                                                child: artwork
                                                        .imageUrl.isNotEmpty
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
                                                                color: Colors
                                                                    .black),
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
                              ).animate().fadeIn();
                            },
                          ),
                        ),
                        Positioned(
                          top: 40,
                          child: GestureDetector(
                            onTap: _closeMenu,
                            child: _showDetailScreen
                                ? const Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 50,
                                    color: Colors.white,
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
                      const Gap(300),
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
