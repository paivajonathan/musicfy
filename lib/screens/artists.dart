import 'package:flutter/material.dart';
import 'package:trabalho1/data/artists.dart';
import 'package:trabalho1/widgets/artist_item.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedArtists = artists;
    sortedArtists.sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: sortedArtists.length,
        itemBuilder: (context, index) {
          final artist = sortedArtists[index];
          return ArtistItem(artist: artist);
        }
      ),
    );
  }
}
