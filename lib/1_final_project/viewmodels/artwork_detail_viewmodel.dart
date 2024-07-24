// lib/1_final_project/viewmodels/artwork_detail_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ArtworkDetailViewModel extends ChangeNotifier {
  final ArtworkRepository artworkRepository;
  Artwork? artwork;
  bool isLoading = false;

  ArtworkDetailViewModel({required this.artworkRepository});

  Future<void> fetchArtworkDetails(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      artwork = await artworkRepository.fetchArtworkDetails(id);
      print(
          'Artwork details fetched successfully: ${artwork.toString()}'); // 디버깅 메시지 추가
    } catch (e) {
      print('Error fetching artwork details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
