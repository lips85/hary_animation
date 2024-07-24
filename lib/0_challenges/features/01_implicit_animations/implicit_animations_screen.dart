import 'dart:async';
import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({
    super.key,
  });

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _change = true;
  Timer? _timer;
  final Duration _duration = const Duration(microseconds: 1300000);

  void _trigger() {
    setState(() {
      _change = !_change;
    });
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(_duration, (timer) {
      _trigger();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _change ? Colors.white : Colors.black,
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: _change ? BoxShape.circle : BoxShape.rectangle,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  child: AnimatedAlign(
                    duration: _duration,
                    alignment:
                        _change ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      width: size.width * 0.05,
                      height: size.width * 0.8,
                      color: _change ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
