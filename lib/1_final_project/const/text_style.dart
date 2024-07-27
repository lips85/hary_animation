import 'package:flutter/material.dart';

class MyText {
  TextStyle titleLarge() {
    return const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle bodyLarge() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
  }
}
