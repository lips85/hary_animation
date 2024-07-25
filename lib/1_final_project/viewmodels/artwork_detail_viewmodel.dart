// lib/1_final_project/viewmodels/artwork_detail_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ArtworkDetailViewModel extends StateNotifier<AsyncValue<Artwork>> {
  final ArtworkRepository artworkRepository;

  ArtworkDetailViewModel(this.artworkRepository)
      : super(const AsyncValue.loading());

  Future<void> fetchArtworkDetails(int id) async {
    try {
      final artwork = await artworkRepository.fetchArtworkDetails(id);
      state = AsyncValue.data(artwork);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final artworkDetailProvider = StateNotifierProvider.family<
    ArtworkDetailViewModel, AsyncValue<Artwork>, int>((ref, id) {
  final repository = ref.watch(artworkRepositoryProvider);
  final viewModel = ArtworkDetailViewModel(repository);
  viewModel.fetchArtworkDetails(id);
  return viewModel;
});
