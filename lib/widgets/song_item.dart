import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/song.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.index,
    this.showArtists = false,
  });

  final Song song;
  final int index;
  final bool showArtists;

  @override
  Widget build(BuildContext context) {
    final subtitle = formatNumber(song.streamsCount) + (
      showArtists
      ? " | ${song.artistsNames.join(", ")}"
      : ""
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: Text((index + 1).toString(), style: const TextStyle(fontSize: 20)),
        title: Text(song.title),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.favorite_border),
      ),
    );
  }
}