import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/models/artist.dart';
import 'package:trabalho1/models/song.dart';
import 'package:trabalho1/providers/favorite_songs.dart';
import 'package:trabalho1/screens/add_edit_artist.dart';
import 'package:trabalho1/screens/add_edit_song.dart';
import 'package:trabalho1/widgets/song_item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabalho1/widgets/title_image.dart';

class ArtistDetailsScreen extends ConsumerStatefulWidget {
  const ArtistDetailsScreen({
    super.key,
    required this.artist,
  });

  final ArtistModel artist;

  @override
  ConsumerState<ArtistDetailsScreen> createState() =>
      _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends ConsumerState<ArtistDetailsScreen> {
  List<SongModel> _songs = [];
  bool _isLoadingSongs = true;
  String? _isLoadingSongsError;

  bool _wasEdited = false;
  late ArtistModel _artistData = widget.artist;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _loadSongs() async {
    try {
      setState(() {
        _isLoadingSongs = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final response = await http.get(url);

      if (response.statusCode > 400) {
        setState(() {
          _songs = [];
          _isLoadingSongsError =
              "Ocorreu um erro inesperado ao tentar carregar as músicas do artista.";
        });

        return;
      }

      final data = json.decode(response.body);

      if (data == null) {
        setState(() {
          _songs = [];
          _isLoadingSongsError = null;
        });

        return;
      }

      final List<SongModel> loadedItems = [];

      for (final item in data.entries) {
        if (item.value["artistId"] != _artistData.id) {
          continue;
        }

        List<String> favoritedBy = [];

        for (final favoritedItem in (item.value["favoritedBy"] ?? {}).entries) {
          favoritedBy.add(favoritedItem.key);
        }

        loadedItems.add(
          SongModel(
            id: item.key,
            title: item.value["title"],
            streamsCount: item.value["streamsCount"],
            artistId: item.value["artistId"],
            favoritedBy: favoritedBy,
          ),
        );
      }

      setState(() {
        _songs = loadedItems;
        _isLoadingSongsError = null;
      });
    } catch (e) {
      setState(() {
        _songs = [];
        _isLoadingSongsError = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingSongs = false;
      });
    }
  }

  Future<void> _handleSongAdd() async {
    final newSong = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddEditSongScreen(
            artistId: _artistData.id,
          );
        },
      ),
    );

    if (newSong == null) {
      return;
    }

    setState(() {
      _songs.add(newSong);
    });
  }

  Future<void> _handleSongEdit(SongModel songData) async {
    Navigator.of(context).pop();

    final editedSong = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddEditSongScreen(
            artistId: _artistData.id,
            songData: songData,
          );
        },
      ),
    );

    if (editedSong == null) {
      return;
    }

    final oldSongIndex = _songs.indexWhere(
      (item) => item.id == editedSong.id,
    );

    setState(() {
      _songs[oldSongIndex] = editedSong;
    });

    ref.read(favoriteSongsProvider.notifier).updateSong(editedSong);
  }

  Future<void> _deleteSong(SongModel songData) async {
    Navigator.of(context).pop();

    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza de que'),
                Text('deseja excluir essa música?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == null || !result) {
      return;
    }

    try {
      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs/${songData.id}.json',
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
                  "Ocorreu um erro inesperado ao tentar excluir a música."),
            ),
          );

        return;
      }

      setState(() {
        _songs = _songs.where((item) => item.id != songData.id).toList();
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Música excluída com sucesso."),
          ),
        );

      ref.read(favoriteSongsProvider.notifier).removeSong(songData);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", ""))));
    }
  }

  Future<void> _handleArtistEdit() async {
    Navigator.of(context).pop();

    final editedArtist = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddEditArtistScreen(
            artistData: _artistData,
          );
        },
      ),
    );

    if (editedArtist == null) {
      return;
    }

    setState(() {
      _artistData = editedArtist;
      _wasEdited = true;
    });
  }

  Future<void> _handleArtistDelete() async {
    Navigator.of(context).pop();

    try {
      final getSongsUrl = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final getSongsResponse = await http.get(getSongsUrl);

      if (getSongsResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao excluir um artista.",
              ),
            ),
          );
      }

      final getSongsResponseData = json.decode(getSongsResponse.body);

      for (final item in getSongsResponseData.entries) {
        if (item.value["artistId"] == _artistData.id) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  "Não é possível excluir o artista, pois possui músicas relacionadas.",
                ),
              ),
            );

          return;
        }
      }

      if (!mounted) {
        return;
      }

      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmação'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Tem certeza de que'),
                  Text('deseja excluir esse artista?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Excluir'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (result == null || !result) {
        return;
      }

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists/${_artistData.id}.json',
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
                "Ocorreu um erro inesperado ao tentar excluir o artista.",
              ),
            ),
          );

        return;
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Artista excluído com sucesso.",
            ),
          ),
        );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
          ),
        );
    }
  }

  Widget _renderSongs() {
    if (_isLoadingSongs) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isLoadingSongsError != null) {
      return Center(
        child: Text(_isLoadingSongsError!),
      );
    }

    if (_songs.isEmpty) {
      return const Center(
        child: Text(
          "Não há músicas cadastradas para esse artista.",
        ),
      );
    }

    _songs.sort(
      (a, b) => b.streamsCount.compareTo(a.streamsCount),
    );

    return Column(
      children: [
        for (final (index, song) in _songs.indexed)
          SongItem(
            song: song,
            index: index,
            onEdit: () => _handleSongEdit(song),
            onDelete: () => _deleteSong(song),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadSongs,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }

          if (_wasEdited) {
            Navigator.of(context).pop(_artistData);
            return;
          }

          Navigator.of(context).pop();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Wrap(
                          children: <Widget>[
                            Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Editar Artista'),
                                  onTap: () => _handleArtistEdit(),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Excluir Artista'),
                                  onTap: () => _handleArtistDelete(),
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
            ],
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              TitleImage(artist: _artistData, isHeader: true),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Músicas",
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        IconButton(
                          onPressed: () => _handleSongAdd(),
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _renderSongs(),
                    const SizedBox(height: 20),
                    Text(
                      "Sobre",
                      style: Theme.of(context).textTheme.titleLarge!,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _artistData.description,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
