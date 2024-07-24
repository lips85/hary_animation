// lib/1_final_project/repositories/artwork_repository.dart
import 'package:hary_animation/1_final_project/services/api_service.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ArtworkRepository {
  final ApiService apiService;

  ArtworkRepository(this.apiService);

  Future<List<Artwork>> fetchArtworks() async {
    final List<dynamic> data = await apiService.fetchArtworks();
    return data.map((item) => Artwork.fromJson(item)).toList();
  }

  Future<Artwork> fetchArtworkDetails(int id) async {
    final Map<String, dynamic> data = await apiService.fetchArtworkDetails(id);
    return Artwork.fromJson(data);
  }
}
