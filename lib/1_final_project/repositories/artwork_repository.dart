// lib/1_final_project/repositories/artwork_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';
import 'package:hary_animation/1_final_project/models/artwork_detail.dart'; // ArtworkDetail 모델 임포트
import 'package:hary_animation/1_final_project/services/api_service.dart';

class ArtworkRepository {
  final ApiService apiService;

  ArtworkRepository(this.apiService);

  Future<List<Artwork>> fetchArtworks() async {
    return await apiService.fetchArtworks();
  }

  Future<ArtworkDetail> fetchArtworkDetails(int id) async {
    // ArtworkDetail 반환
    return await apiService.fetchArtworkDetails(id);
  }
}

final artworkRepositoryProvider = Provider<ArtworkRepository>((ref) {
  return ArtworkRepository(ref.read(apiServiceProvider));
});
