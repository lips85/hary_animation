import 'dart:math';
import 'package:flutter/material.dart';

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

  final List<String> quotes = [
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Do not wait to strike till the iron is hot; but make it hot by striking.",
    "Great minds discuss ideas; average minds discuss events; small minds discuss people.",
    "The best way to predict the future is to invent it.",
    "You miss 100% of the shots you don't take."
  ];

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
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
      _backgroundColor = Colors.blue.shade300;
      _positionController.value = 0;
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
          .whenComplete(() {
        setState(() {
          _backgroundColor = Colors.blue.shade300;
        });
      });
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
          ? Stack(
              children: [
                AnimatedContainer(
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
                              child: Cards(
                                index: _index == 5 ? 1 : _index + 1,
                                quote: quotes[_index == 5 ? 0 : _index],
                                isFlipped: _flipAnimation.value >= 0.5,
                              ),
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
                                                quote: quotes[_index - 1],
                                                isFlipped:
                                                    _flipAnimation.value >= 0.5,
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
                                                  index: _index,
                                                  quote: quotes[_index - 1],
                                                  isFlipped:
                                                      _flipAnimation.value >=
                                                          0.5,
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
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: CustomPaint(
                    painter: ProgressBarPainter(_index),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}

class Cards extends StatelessWidget {
  final int index;
  final String quote;
  final bool isFlipped;

  const Cards({
    super.key,
    required this.index,
    required this.quote,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Center(
        child: isFlipped
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Text(
                'Card $index',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final int index;

  ProgressBarPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    const totalCards = 5;
    final progress = (index / totalCards);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      const Radius.circular(10),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
