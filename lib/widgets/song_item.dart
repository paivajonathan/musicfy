import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/song.dart';
import 'package:trabalho1/providers/favorite_songs.dart';

class SongItem extends ConsumerWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.index,
    this.showDataManipulationActions = true,
    this.showArtist = false,
    this.onEdit,
    this.onDelete,
  });

  final SongModel song;
  final int index;
  final bool showDataManipulationActions;
  final bool showArtist;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitle = formatNumber(song.streamsCount) +
        (showArtist ? " | ${song.artistName}" : "");

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
                      title: ref
                              .read(favoriteSongsProvider.notifier)
                              .isFavorite(song)
                          ? const Text('Remover dos Favoritos')
                          : const Text("Adicionar aos favoritos"),
                      onTap: () {
                        ref
                            .read(favoriteSongsProvider.notifier)
                            .toggleSongFavoriteStatus(song);

                        Navigator.of(context).pop();

                        String message = ref
                                .read(favoriteSongsProvider.notifier)
                                .isFavorite(song)
                            ? "Música adicionada aos Favoritos."
                            : "Música removida dos Favoritos";

                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(message)));
                      },
                    ),
                    if (showDataManipulationActions)
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Editar Música'),
                            onTap: onEdit,
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Excluir Música'),
                            onTap: onDelete,
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
