// lib/1_final_project/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hary_animation/1_final_project/services/api_service.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/views/home_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ArtworkListViewModel(
            artworkRepository: ArtworkRepository(ApiService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Art Institute of Chicago',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
