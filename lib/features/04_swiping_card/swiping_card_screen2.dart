import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCard2Screen extends StatefulWidget {
  const SwipingCard2Screen({super.key});

  @override
  State<SwipingCard2Screen> createState() => _SwipingCard2ScreenState();
}

class _SwipingCard2ScreenState extends State<SwipingCard2Screen>
    with SingleTickerProviderStateMixin {
  late final screenSize = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: screenSize.width * -1,
    upperBound: screenSize.width * 1,
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position.value += details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _position.animateTo(
        0,
      );
    });
  }

  @override
  void dispose() {
    _position.dispose();
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
            animation: _position,
            builder: (context, child) {
              final angle = _rotation.transform(
                (_position.value + screenSize.width / 2) / screenSize.width,
              );

              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      onHorizontalDragEnd: _onHorizontalDragEnd,
                      child: Transform.translate(
                        offset: Offset(_position.value, 0),
                        child: Transform.rotate(
                          angle: angle * pi / 180,
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
