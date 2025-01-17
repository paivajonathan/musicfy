import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/song.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho1/providers/favorite_songs.dart';
import 'package:trabalho1/providers/user_data.dart';

class SongItem extends ConsumerStatefulWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.index,
    this.showDataManipulationActions = true,
    this.onEdit,
    this.onDelete,
  });

  final SongModel song;
  final int index;
  final bool showDataManipulationActions;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  ConsumerState<SongItem> createState() => _SongItemState();
}

class _SongItemState extends ConsumerState<SongItem> {
  bool _isTogglingFavorite = false;

  Future<void> _addFavoriteSong() async {
    if (_isTogglingFavorite) {
      return;
    }

    try {
      final userDataState = ref.watch(userDataProvider);
      final favoriteSongsNotifier = ref.read(favoriteSongsProvider.notifier);

      setState(() {
        _isTogglingFavorite = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs/${widget.song.id}/favoritedBy/${userDataState!.id}.json',
      );

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'favorited': true
          }
        ),
      );

      if (response.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao adicionar música aos favoritos.",
              ),
            ),
          );
      }

      favoriteSongsNotifier.addSong(widget.song);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Música adicionada aos favoritos.",
            ),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
          ),
        );
    } finally {
      setState(() {
        _isTogglingFavorite = false;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _removeFavoriteSong() async {
    if (_isTogglingFavorite) {
      return;
    }

    try {
      final userDataState = ref.watch(userDataProvider);
      final favoriteSongsNotifier = ref.read(favoriteSongsProvider.notifier);

      setState(() {
        _isTogglingFavorite = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs/${widget.song.id}/favoritedBy/${userDataState!.id}.json',
      );

      final response = await http.delete(url);

      if (response.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao remover música dos favoritos.",
              ),
            ),
          );
      }

      favoriteSongsNotifier.removeSong(widget.song);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Música removida dos favoritos.",
            ),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
          ),
        );
    } finally {
      setState(() {
        _isTogglingFavorite = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSongsNotifier = ref.read(favoriteSongsProvider.notifier);

    final subtitle = formatNumber(widget.song.streamsCount);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text((widget.index + 1).toString(),
          style: const TextStyle(fontSize: 20)),
      title: Text(widget.song.title),
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
                      title: favoriteSongsNotifier.isFavorite(widget.song)
                          ? const Text('Remover dos Favoritos')
                          : const Text("Adicionar aos favoritos"),
                      onTap: favoriteSongsNotifier.isFavorite(widget.song)
                       ? () => _removeFavoriteSong()
                       : () => _addFavoriteSong()
                    ),
                    if (widget.showDataManipulationActions)
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Editar Música'),
                            onTap: widget.onEdit,
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Excluir Música'),
                            onTap: widget.onDelete,
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
