import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/song.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.index,
  });

  final int index;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: Text((index + 1).toString(), style: const TextStyle(fontSize: 20)),
        title: Text(song.title),
        subtitle: Text(formatNumber(song.streamsCount)),
        trailing: const Icon(Icons.favorite_border),
      ),
    );
  }
}