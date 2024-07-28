// lib/1_final_project/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ApiService {
  final String _baseUrl = 'https://api.artic.edu/api/v1';

  Future<List<Artwork>> fetchArtworks() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/artworks?limit=100&fields=id,title,artist_title,image_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Artwork> artworks = List<Artwork>.from(data['data'].map((artwork) {
        artwork['image_url'] = artwork['image_id'] != null &&
                artwork['image_id'].isNotEmpty
            ? 'https://www.artic.edu/iiif/2/${artwork['image_id']}/full/800,/0/default.jpg'
            : '';
        return Artwork.fromJson(artwork);
      }));

      // artist_title 순서로 정렬, null 값은 마지막으로
      artworks.sort((a, b) {
        String artistA = a.artistTitle;
        String artistB = b.artistTitle;
        return artistA.compareTo(artistB);
      });

      return artworks;
    } else {
      throw Exception('Failed to load artworks');
    }
  }

  Future<Artwork> fetchArtworkDetails(int id) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/artworks/$id?fields=id,title,artist_title,image_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      data['image_url'] = data['image_id'] != null &&
              data['image_id'].isNotEmpty
          ? 'https://www.artic.edu/iiif/2/${data['image_id']}/full/800,/0/default.jpg'
          : '';
      return Artwork.fromJson(data);
    } else {
      throw Exception('Failed to load artwork details');
    }
  }
}

final apiServiceProvider = Provider((ref) => ApiService());
