import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/providers/favorite_songs.dart';
import 'package:trabalho1/widgets/song_item.dart';

class FavoriteSongsScreen extends ConsumerWidget {
  const FavoriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(favoriteSongsProvider);
    songs.sort((a, b) => b.streamsCount.compareTo(a.streamsCount));

    if (songs.isEmpty) {
      return const Center(child: Text("Não há músicas favoritadas."));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return SongItem(
            song: song,
            index: index,
            showArtist: true,
            showDataManipulationActions: false,
          );
        },
      ),
    );
  }
}
