// lib/1_final_project/viewmodels/artwork_list_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';

class ArtworkListViewModel extends StateNotifier<List<Artwork>> {
  final ArtworkRepository artworkRepository;

  ArtworkListViewModel(this.artworkRepository) : super([]);

  Future<void> fetchArtworks() async {
    final artworks = await artworkRepository.fetchArtworks();
    state = artworks;
  }
}

final artworkListProvider =
    StateNotifierProvider<ArtworkListViewModel, List<Artwork>>((ref) {
  return ArtworkListViewModel(ref.watch(artworkRepositoryProvider));
});
