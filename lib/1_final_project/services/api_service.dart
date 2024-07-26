// lib/1_final_project/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ApiService {
  final String _baseUrl = 'https://api.artic.edu/api/v1';

  Future<List<Artwork>> fetchArtworks() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/artworks?fields=id,title,artist_display,image_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']
          .map<Artwork>((json) => Artwork.fromJson(json))
          .toList();
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
