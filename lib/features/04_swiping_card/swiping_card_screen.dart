import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hary_animation/features/04_swiping_card/widgets/card.dart';

class SwipingCard2sScreen extends StatefulWidget {
  const SwipingCard2sScreen({super.key});

  @override
  State<SwipingCard2sScreen> createState() => _SwipingCard2sScreenState();
}

class _SwipingCard2sScreenState extends State<SwipingCard2sScreen>
    with TickerProviderStateMixin {
  late final AnimationController _positionController;
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final Tween<double> _rotation;
  late final Tween<double> _scale;

  Color _backgroundColor = Colors.blue.shade300;

  int _index = 1;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _rotation = Tween(begin: -15, end: 15);
    _scale = Tween(begin: 0.8, end: 1);
  }

  void _initializeControllers(BuildContext context) {
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;

      _positionController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: (size.width + 100) * -1,
        upperBound: (size.width + 100),
        value: 0.0,
      );

      _isInitialized = true;
    }
  }

  void _updateBackgroundColor() {
    setState(() {
      if (_positionController.value > 0) {
        _backgroundColor = Colors.green.shade300;
      } else if (_positionController.value < 0) {
        _backgroundColor = Colors.red.shade300;
      } else {
        _backgroundColor = Colors.blue.shade300;
      }
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _positionController.value += details.delta.dx;
    _updateBackgroundColor();
  }

  void _whenComplete() {
    _positionController.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
      _backgroundColor = Colors.blue.shade300;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_positionController.value.abs() >= bound) {
      if (_positionController.value.isNegative) {
        _positionController
            .animateTo((dropZone) * -1)
            .whenComplete(_whenComplete);
      } else {
        _positionController.animateTo(dropZone).whenComplete(_whenComplete);
      }
    } else {
      _positionController
          .animateTo(
            0,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    }
  }

  void _flipCard() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _positionController.dispose();
    }
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Card2s'),
      ),
      body: _isInitialized
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: _backgroundColor,
              child: AnimatedBuilder(
                animation: _positionController,
                builder: (context, child) {
                  final angle = _rotation.transform(
                        (_positionController.value +
                                MediaQuery.of(context).size.width / 2) /
                            MediaQuery.of(context).size.width,
                      ) *
                      pi /
                      180;
                  final scale = _scale.transform(
                      _positionController.value.abs() /
                          MediaQuery.of(context).size.width);
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 100,
                        child: Transform.scale(
                          scale: scale,
                          child: Cards(index: _index == 5 ? 1 : _index + 1),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        child: GestureDetector(
                          onTap: _flipCard,
                          onHorizontalDragUpdate: _onHorizontalDragUpdate,
                          onHorizontalDragEnd: _onHorizontalDragEnd,
                          child: AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              final flipAngle = _flipAnimation.value * pi;
                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(flipAngle),
                                alignment: Alignment.center,
                                child: _flipAnimation.value <= 0.5
                                    ? Transform.translate(
                                        offset: Offset(
                                            _positionController.value, 0),
                                        child: Transform.rotate(
                                          angle: angle,
                                          child: Cards(
                                            index: _index,
                                          ),
                                        ),
                                      )
                                    : Transform(
                                        transform: Matrix4.identity()
                                          ..rotateY(pi),
                                        alignment: Alignment.center,
                                        child: Transform.translate(
                                          offset: Offset(
                                              _positionController.value, 0),
                                          child: Transform.rotate(
                                            angle: angle,
                                            child: Cards(
                                              index:
                                                  _index, // Flip한 후에도 같은 카드로 유지
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          : Container(),
    );
  }
}
