// lib/1_final_project/models/artwork.dart
class Artwork {
  final int id;
  final String title;
  final String artistTitle;
  final String imageUrl;

  Artwork({
    required this.id,
    required this.title,
    required this.artistTitle,
    required this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      artistTitle: json['artist_title'] ?? "Unkwon",
      imageUrl: json['image_url'] ?? '',
    );
  }
}
