import 'package:flutter/material.dart';

class SwipingCardScreen extends StatefulWidget {
  const SwipingCardScreen({super.key});

  @override
  State<SwipingCardScreen> createState() => _SwipingCardScreenState();
}

class _SwipingCardScreenState extends State<SwipingCardScreen>
    with SingleTickerProviderStateMixin {
  late final screenSize = MediaQuery.of(context).size;
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    lowerBound: screenSize.width * -1,
    upperBound: screenSize.width * 1,
    value: 0.0,
  );

  double posX = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _animationController.value += details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _animationController.animateTo(
        0,
        curve: Curves.bounceOut,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Swiping Card"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      onHorizontalDragEnd: _onHorizontalDragEnd,
                      child: Transform.translate(
                        offset: Offset(_animationController.value, 0),
                        child: Material(
                          elevation: 10,
                          color: Colors.red.shade100,
                          child: SizedBox(
                            width: screenSize.width * 0.8,
                            height: screenSize.height * 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Material(
                  //   elevation: 10,
                  //   color: Colors.yellow.shade300,
                  //   child: SizedBox(
                  //     width: screenSize.width * 0.8,
                  //     height: screenSize.height * 0.8,
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
