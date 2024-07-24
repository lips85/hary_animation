// lib/1_final_project/models/artwork.dart
class Artwork {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;

  Artwork(
      {required this.id,
      required this.title,
      required this.artist,
      required this.imageUrl});

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      artist: json['artist_display'],
      imageUrl: json['image_url'] ?? '', // JSON에서 이미지 URL 가져오기, 없을 경우 빈 문자열
    );
  }
}
