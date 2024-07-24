// lib/1_final_project/viewmodels/artwork_list_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ArtworkListViewModel extends ChangeNotifier {
  final ArtworkRepository artworkRepository;
  List<Artwork> artworks = [];
  bool isLoading = false;

  ArtworkListViewModel({required this.artworkRepository});

  Future<void> fetchArtworks() async {
    isLoading = true;
    notifyListeners();
    try {
      artworks = await artworkRepository.fetchArtworks();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
