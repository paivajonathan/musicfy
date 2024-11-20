import 'package:flutter/material.dart';
import 'package:trabalho1/data/songs.dart';
import 'package:trabalho1/models/artist.dart';
import 'package:trabalho1/widgets/song_item.dart';
import 'package:trabalho1/widgets/title_image.dart';

const int _kMaxSongsCount = 5;

class ArtistDetailsScreen extends StatelessWidget {
  const ArtistDetailsScreen({
    super.key,
    required this.artist,
  });

  final Artist artist;

  Widget _getSongsView(BuildContext context) {
    final filteredSongs = songs.where((song) => song.artists.contains(artist.id)).toList();
    filteredSongs.sort((a, b) => b.streamsCount.compareTo(a.streamsCount));

    if (filteredSongs.isNotEmpty) {
      final count = filteredSongs.length >= _kMaxSongsCount
        ? _kMaxSongsCount
        : filteredSongs.length;

      return Column(
        children: [
          for (int i = 0; i < count; i++)
            SongItem(
              song: filteredSongs[i],
              index: i,
            )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Nenhuma música encontrada.",
        style: Theme.of(context).textTheme.bodyLarge!
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleImage(artist: artist, isHeader: true),
            _getSongsView(context),
            Text(
              "Sobre",
              style: Theme.of(context).textTheme.titleLarge!
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Text(
                artist.description,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge!
              ),
            ),
          ],
        ),
      ),
    );
  }
}
