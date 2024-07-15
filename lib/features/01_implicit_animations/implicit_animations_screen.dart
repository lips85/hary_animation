import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({
    super.key,
  });

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  // final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 1),
  //   vsync: this,
  // );
  bool _change = false;
  void _trigger() {
    setState(() {
      _change = !_change;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _change ? Colors.black : Colors.white,
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
                    shape: _change ? BoxShape.rectangle : BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  child: AnimatedAlign(
                    duration: const Duration(seconds: 1),
                    alignment:
                        _change ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: size.width * 0.05,
                      height: size.width * 0.8,
                      color: _change ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text("Go"),
            )
          ],
        ),
      ),
    );
  }
}
