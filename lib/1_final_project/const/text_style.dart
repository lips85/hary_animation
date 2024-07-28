import 'package:flutter/material.dart';

class MyText {
  TextStyle titleLarge() {
    return const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle bodyLarge() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}
