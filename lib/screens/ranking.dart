import 'package:flutter/material.dart';
import 'package:trabalho1/data/songs.dart';
import 'package:trabalho1/widgets/song_item.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sortedSongs = songs;
    sortedSongs.sort((a, b) => b.streamsCount.compareTo(a.streamsCount));

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedSongs.length,
      itemBuilder: (context, index) {
        final song = sortedSongs[index];
        return SongItem(
          song: song,
          index: index,
          showArtists: true,
        );
      }
    );
  }
}
