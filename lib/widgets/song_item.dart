import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/song.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.index,
    this.showDataManipulationActions = true,
    this.showArtists = false,
  });

  final SongModel song;
  final int index;
  final bool showDataManipulationActions;
  final bool showArtists;

  @override
  Widget build(BuildContext context) {
    final subtitle = formatNumber(song.streamsCount) +
        (showArtists ? " | ${song.artistName}" : "");

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          Text((index + 1).toString(), style: const TextStyle(fontSize: 20)),
      title: Text(song.title),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Adicionar aos favoritos'),
                      onTap: () => {},
                    ),
                    if (showDataManipulationActions)
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Editar'),
                            onTap: () => {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Excluir'),
                            onTap: () => {},
                          ),
                        ],
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
