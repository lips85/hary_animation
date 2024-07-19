import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomPainterScreen extends StatefulWidget {
  const CustomPainterScreen({super.key});

  @override
  State<CustomPainterScreen> createState() => _CustomPainterScreenState();
}

class _CustomPainterScreenState extends State<CustomPainterScreen> {
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
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.rotate_left_sharp,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(20),
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.stop,
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
