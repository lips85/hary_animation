// lib/1_final_project/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hary_animation/1_final_project/viewmodels/artwork_list_viewmodel.dart';
import 'package:hary_animation/1_final_project/widgets/artwork_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArtworkListViewModel>(context, listen: false).fetchArtworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Institute of Chicago'),
      ),
      body: Consumer<ArtworkListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.artworks.isEmpty) {
            return const Center(child: Text('No artworks found!'));
          } else {
            return ListView.builder(
              itemCount: viewModel.artworks.length,
              itemBuilder: (context, index) {
                return ArtworkListItem(artwork: viewModel.artworks[index]);
              },
            );
          }
        },
      ),
    );
  }
}
