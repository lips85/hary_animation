import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomPainter2Screen extends StatefulWidget {
  const CustomPainter2Screen({super.key});

  @override
  State<CustomPainter2Screen> createState() => _CustomPainter2ScreenState();
}

class _CustomPainter2ScreenState extends State<CustomPainter2Screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: setTime),
  );

  int setTime = 10;
  bool _pressedPlay = false;
  bool _selected = false;
  int _minutes = 0;
  int _seconds = 10;

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      setState(() {});
      if (_animationController.isCompleted) {
        Timer(
          const Duration(seconds: 1),
          () {
            setState(() {
              _pressedPlay = false;
              _animationController.reset();
            });
          },
        );
      }
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

  void increaseMinute() {
    if (_minutes < 60) {
      setState(() {
        _minutes = _minutes + 1;
      });
    }
  }

  void decreaseMinute() {
    if (_minutes > 0) {
      setState(() {
        _minutes = _minutes - 1;
      });
    }
  }

  void increaseSecond() {
    if (_seconds < 60) {
      setState(() {
        _seconds = _seconds + 1;
      });
    }
  }

  void decreaseSecond() {
    if (_seconds > 0) {
      setState(() {
        _seconds = _seconds - 1;
      });
    }
  }

  void _confirmSetTime() {
    _setTime(_minutes * 60 + _seconds);
  }

  void _setTime(int time) {
    setState(() {
      setTime = time;
      _animationController.duration = Duration(seconds: setTime);
      _animationController.reset();
      _selected = true;
    });
  }

  List<String> _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return [minutes, ":", seconds];
  }

  String joinStrings(List<String> stringList, [String delimiter = ""]) {
    return stringList.join(delimiter);
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (_selected && !_pressedPlay)
                  ? Colors.green
                  : Colors.red.shade200,
            ),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    if (!_pressedPlay) {
                      _confirmSetTime();
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(
                              height: 80,
                              width: 50,
                            ),
                            Positioned(
                              top: 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: increaseMinute,
                                icon: const Icon(
                                  Icons.arrow_drop_up_rounded,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: decreaseMinute,
                                icon: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    (_minutes < 10)
                        ? Text(
                            joinStrings(["0", _minutes.toString()]),
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            _minutes.toString(),
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    const Text(
                      ":",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (_seconds < 10)
                        ? Text(
                            joinStrings(["0", _seconds.toString()]),
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            _seconds.toString(),
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(
                              height: 80,
                              width: 50,
                            ),
                            Positioned(
                              top: 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: increaseSecond,
                                icon: const Icon(
                                  Icons.arrow_drop_up_rounded,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: decreaseSecond,
                                icon: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(50),
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  joinStrings(_formatDuration(remaining)),
                  key:
                      ValueKey<String>(joinStrings(_formatDuration(remaining))),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade300,
                  ),
                ),
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
          const Gap(70),
          Row(
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
          ),
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
      ..color = Colors.grey.shade300
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
