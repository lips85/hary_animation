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
  );

  int setTime = 10;
  bool _pressedPlay = false;
  bool _selected = false;

  final List settingTime = [10, 20, 30, 40, 50, 60, 120];

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    setState(() {
      setTime = time;
      _animationController.duration = Duration(seconds: setTime);
      _animationController.reset();
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
  Widget build(BuildContext context) {
    Duration remaining =
        _animationController.duration! * (1 - _animationController.value);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Custom Painter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50, // 고정된 높이 설정
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: settingTime.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Gap(20);
              },
              itemBuilder: (BuildContext context, int index) {
                return AnimatedOpacity(
                  opacity: _selected ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 500),
                  child: TextButton(
                    onPressed: () {
                      if (!_pressedPlay) {
                        _setTime(settingTime[index]);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade300, // 배경 색상
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // 패딩
                      textStyle: const TextStyle(fontSize: 16), // 텍스트 스타일
                    ),
                    child: Text(
                      "${settingTime[index].toString()}초",
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(100),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                _formatDuration(remaining),
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
          ),
          const Gap(100),
          _selected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: _selected ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 500),
                      child: IconButton.filled(
                        iconSize: 40,
                        onPressed: _reset,
                        icon: const Icon(Icons.rotate_left_sharp),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const Gap(20),
                    AnimatedOpacity(
                      opacity: _selected ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 500),
                      child: IconButton.filled(
                        padding: const EdgeInsets.all(25),
                        iconSize: 40,
                        onPressed: _pressedPlay ? _stop : _play,
                        icon: _pressedPlay
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.shade300,
                        ),
                      ),
                    ),
                    const Gap(20),
                    AnimatedOpacity(
                      opacity: _selected ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 500),
                      child: IconButton.filled(
                        iconSize: 40,
                        onPressed: _stop,
                        icon: const Icon(Icons.stop),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
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
      ..color = Colors.red.shade300
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
