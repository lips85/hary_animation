import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/router.dart';
import 'package:hary_animation/1_final_project/const/text_style.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ProviderScope(child: HaryFinalAnimation()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HaryFinalAnimation extends StatelessWidget {
  const HaryFinalAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Institute of Chicago',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Vic Hand",
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
