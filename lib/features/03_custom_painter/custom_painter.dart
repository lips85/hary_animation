import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomPainterScreen extends StatefulWidget {
  const CustomPainterScreen({super.key});

  @override
  State<CustomPainterScreen> createState() => _CustomPainterScreenState();
}

class _CustomPainterScreenState extends State<CustomPainterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
    reverseDuration: const Duration(seconds: 2),
  );

  bool _pressedPlay = false;

  void _play() {
    // _animationController.forward();
    setState(() {
      _pressedPlay = !_pressedPlay;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Custom Painter'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              painter: PomodoroPainter(),
              child: const SizedBox(
                width: 300,
                height: 300,
              ),
            ),
            const Gap(100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(Icons.rotate_left_sharp),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade300, // 회색 배경색 설정
                  ),
                ),
                const Gap(20), // 아이콘 간 간격을 위해 추가
                IconButton.filled(
                  padding: const EdgeInsets.all(25),
                  iconSize: 40,
                  onPressed: _play,
                  icon: _pressedPlay
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red, // 회색 배경색 설정
                  ),
                ),
                const Gap(20), // 아이콘 간 간격을 위해 추가
                IconButton.filled(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(Icons.stop),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade300, // 회색 배경색 설정
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class PomodoroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final timePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final basePaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      radius,
      basePaint,
    );

    canvas.drawArc(
      redArcRect,
      -0.5 * pi,
      1.5 * pi,
      false,
      timePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
