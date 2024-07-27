// lib/1_final_project/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ApiService {
  final String _baseUrl = 'https://api.artic.edu/api/v1';

  Future<List<Artwork>> fetchArtworks() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/artworks?limit=100&fields=id,title,artist_display,image_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final artworks = (data['data'] as List)
          .where(
              (json) => json['image_id'] != null && json['image_id'].isNotEmpty)
          .map<Artwork>((json) => Artwork.fromJson(json))
          .toList();

      // 중복 제거 및 작가 이름순으로 정렬
      final uniqueArtworks = {
        for (var artwork in artworks) artwork.title: artwork
      }.values.toList();
      uniqueArtworks.sort((a, b) => a.artist.compareTo(b.artist));
      return uniqueArtworks;
    } else {
      throw Exception('Failed to load artworks');
    }
  }

  Future<Artwork> fetchArtworkDetails(int id) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/artworks/$id?fields=id,title,artist_display,image_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Artwork.fromJson(data);
    } else {
      throw Exception('Failed to load artwork details');
    }
  }
}

final apiServiceProvider = Provider((ref) => ApiService());
