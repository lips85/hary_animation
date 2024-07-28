// lib/1_final_project/models/artwork_detail.dart
class ArtworkDetail {
  final int id;
  final String title;
  final String artistTitle;
  final String imageUrl;
  final String description; // 추가 필드
  final String date; // 추가 필드
  final String medium; // 추가 필드

  ArtworkDetail({
    required this.id,
    required this.title,
    required this.artistTitle,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.medium,
  });

  factory ArtworkDetail.fromJson(Map<String, dynamic> json) {
    return ArtworkDetail(
      id: json['id'],
      title: json['title'],
      artistTitle: json['artist_title'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      medium: json['medium'] ?? '',
    );
  }
}
