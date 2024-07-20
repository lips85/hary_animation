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
    duration: Duration(seconds: setTime),
    lowerBound: 0.0005,
    upperBound: 2.0,
  );

  int setTime = 10;

  bool _pressedPlay = false;
  bool _selected = false;

  void _play() {
    _animationController.forward();
    setState(() {
      _pressedPlay = true;
    });
  }

  void _reset() {
    _animationController.reset();
    setState(() {
      _pressedPlay = false;
    });
  }

  void _stop() {
    _animationController.stop();
    setState(() {
      _pressedPlay = false;
    });
  }

  void _setTime(int time) {
    setTime = time;
    _animationController.duration = Duration(seconds: setTime);
    _animationController.reset(); // 타이머 초기화
    setState(() {
      _selected = true;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
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
          OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _setTime(10);
                },
                child: const Text(
                  "10초",
                ),
              ),
              TextButton(
                onPressed: () {
                  _setTime(60);
                },
                child: const Text(
                  "1분",
                ),
              ),
            ],
          ),
          const Gap(100),
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              Duration remaining = _animationController.duration! *
                  (1 - _animationController.value);
              // 초기 시작 시간을 표시
              String displayTime = _pressedPlay
                  ? _formatDuration(remaining)
                  : _formatDuration(Duration(seconds: setTime));
              return Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    displayTime,
                    style: const TextStyle(fontSize: 24),
                  ),
                  CustomPaint(
                    painter: PomodoroPainter(
                      progress: _animationController.value,
                    ),
                    child: const SizedBox(
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
              );
            },
          ),
          const Gap(100),
          _selected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      iconSize: 40,
                      onPressed: _reset,
                      icon: const Icon(Icons.rotate_left_sharp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    const Gap(20),
                    IconButton.filled(
                      padding: const EdgeInsets.all(25),
                      iconSize: 40,
                      onPressed: _pressedPlay ? _stop : _play,
                      icon: _pressedPlay
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    const Gap(20),
                    IconButton.filled(
                      iconSize: 40,
                      onPressed: _stop,
                      icon: const Icon(Icons.stop),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: SizedBox(
                    height: 90,
                  ),
                )
        ],
      ),
    );
  }
}

class PomodoroPainter extends CustomPainter {
  final double progress;

  PomodoroPainter({
    required this.progress,
  });

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
      progress * 2 * pi,
      false,
      timePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
