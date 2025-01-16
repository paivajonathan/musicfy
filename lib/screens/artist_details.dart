import 'package:flutter/material.dart';
import 'package:trabalho1/models/artist.dart';
import 'package:trabalho1/models/song.dart';
import 'package:trabalho1/screens/add_artist.dart';
import 'package:trabalho1/screens/add_song.dart';
import 'package:trabalho1/widgets/song_item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabalho1/widgets/title_image.dart';

class ArtistDetailsScreen extends StatefulWidget {
  ArtistDetailsScreen({
    super.key,
    required this.artist,
  });

  final ArtistModel artist;

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  List<SongModel> _songs = [];
  bool _isLoadingSongs = true;
  String? _isLoadingSongsError;

  bool _wasEdited = false;
  late ArtistModel _artistData = widget.artist;

  Future<void> _loadSongs() async {
    try {
      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final response = await http.get(url);
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

        loadedItems.add(
          SongModel(
            id: item.key,
            title: item.value["title"],
            streamsCount: item.value["streamsCount"],
            artistId: item.value["artistId"],
            artistName: item.value["artistName"],
          ),
        );
      }

      setState(() {
        _songs = loadedItems;
        _isLoadingSongsError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(e.toString())));

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

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadSongs,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_wasEdited) {
                Navigator.of(context).pop(_artistData);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
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
                                onTap: () async {
                                  Navigator.of(context).pop();

                                  final editedArtist =
                                      await Navigator.of(context).push(
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
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Excluir Artista'),
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
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
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
                          onPressed: () async {
                            final newSong = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddSongScreen(
                                    artistId: _artistData.id,
                                    artistName: _artistData.name,
                                  );
                                },
                              ),
                            );

                            if (newSong == null) {
                              return;
                            }

                            setState(() {
                              _wasEdited = true;
                              _songs.add(newSong);
                            });
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        if (_isLoadingSongs) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (_isLoadingSongsError != null) {
                          return Center(child: Text(_isLoadingSongsError!));
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
                              SongItem(song: song, index: index)
                          ],
                        );
                      },
                    ),
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
