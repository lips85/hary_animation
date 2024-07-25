// lib/1_final_project/widgets/artwork_list_item.dart
import 'package:flutter/material.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';
import 'package:hary_animation/1_final_project/views/artwork_detail_screen.dart';

class ArtworkListItem extends StatelessWidget {
  final Artwork artwork;

  const ArtworkListItem({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: artwork.imageUrl.isNotEmpty
          ? Image.network(artwork.imageUrl,
              width: 50, height: 50, fit: BoxFit.cover)
          : Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: const Icon(Icons.image, color: Colors.white)),
      title: Text(artwork.title),
      subtitle: Text(artwork.artist),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtworkDetailScreen(artworkId: artwork.id),
          ),
        );
      },
    );
  }
}
