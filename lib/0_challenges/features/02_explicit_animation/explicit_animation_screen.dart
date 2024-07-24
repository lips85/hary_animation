import 'package:flutter/material.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
    reverseDuration: const Duration(seconds: 2),
  );

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _reverse() {
    _animationController.reverse();
  }

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5),
    ),
    end: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(5),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 2.0,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
  ).animate(_curve);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.2),
  ).animate(_curve);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Explicit Animations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: SlideTransition(
                    position: _position,
                    child: ScaleTransition(
                      scale: _scale,
                      child: RotationTransition(
                        turns: _rotation,
                        child: DecoratedBoxTransition(
                          decoration: _decoration,
                          child: SizedBox(
                            width: screenSize.width * 0.1,
                            height: screenSize.width * 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _play,
                child: const Text("play"),
              ),
              ElevatedButton(
                onPressed: _pause,
                child: const Text("pause"),
              ),
              ElevatedButton(
                onPressed: _reverse,
                child: const Text("reverse"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
