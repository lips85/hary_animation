// lib/1_final_project/models/artwork.dart
class Artwork {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['image_id'] != null && json['image_id'].isNotEmpty) {
      imageUrl =
          'https://www.artic.edu/iiif/2/${json['image_id']}/full/600,/0/default.jpg';
    }
    return Artwork(
      id: json['id'],
      title: json['title'],
      artist: json['artist_display'] ?? '',
      imageUrl: imageUrl,
    );
  }
}
