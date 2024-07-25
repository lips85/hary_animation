// lib/1_final_project/views/artwork_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_detail_viewmodel.dart';
import 'package:hary_animation/1_final_project/repositories/artwork_repository.dart';
import 'package:hary_animation/1_final_project/services/api_service.dart';
import 'package:hary_animation/1_final_project/models/artwork.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final int artworkId;

  const ArtworkDetailScreen({super.key, required this.artworkId});

  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  late ArtworkDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ArtworkDetailViewModel(
      artworkRepository: ArtworkRepository(ApiService()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchArtworkDetails(widget.artworkId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Artwork Details'),
        ),
        body: Consumer<ArtworkDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.artwork == null) {
              return const Center(child: Text('No artwork found!'));
            } else {
              Artwork artwork = viewModel.artwork!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    artwork.imageUrl.isNotEmpty
                        ? Image.network(artwork.imageUrl, fit: BoxFit.cover)
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artwork.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Artist: ${artwork.artist}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
