import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trabalho1/models/artist.dart';
import 'package:trabalho1/screens/add_edit_artist.dart';
import 'package:trabalho1/screens/artist_details.dart';
import 'package:trabalho1/widgets/artist_item.dart';
import 'package:http/http.dart' as http;

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List<ArtistModel> _artists = [];
  bool _isLoadingArtists = true;
  String? _isLoadingArtistsError;

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _loadArtists() async {
    try {
      setState(() {
        _isLoadingArtists = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists.json',
      );

      final response = await http.get(url);

      if (response.statusCode > 400) {
        setState(() {
          _artists = [];
          _isLoadingArtistsError =
              "Ocorreu um erro inesperado ao tentar carregar os artistas.";
        });
        return;
      }

      final data = json.decode(response.body);

      if (data == null) {
        setState(() {
          _artists = [];
          _isLoadingArtistsError = null;
        });

        return;
      }

      final List<ArtistModel> loadedItems = [];

      for (final item in data.entries) {
        loadedItems.add(
          ArtistModel(
            id: item.key,
            name: item.value["name"],
            imageUrl: item.value["imageUrl"],
            followers: item.value["followersQuantity"],
            description: item.value["description"],
          ),
        );
      }

      setState(() {
        _artists = loadedItems;
        _isLoadingArtistsError = null;
      });
    } on http.ClientException catch (_) {
      setState(() {
        _artists = [];
        _isLoadingArtistsError = "Verifique a sua conexão com a internet.";
      });
    } catch (e) {
      setState(() {
        _artists = [];
        _isLoadingArtistsError = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isLoadingArtists = false;
      });
    }
  }

  Future<void> _handleArtistAdd() async {
    final newArtist = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddEditArtistScreen(),
      ),
    );

    if (newArtist == null) {
      return;
    }

    setState(() {
      _artists.add(newArtist);
    });
  }

  Future<void> _handleArtistEditDelete(ArtistModel artist) async {
    final editedRemovedArtist = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArtistDetailsScreen(
          artist: artist,
        ),
      ),
    );

    // If the artist wasn't deleted or edited
    if (editedRemovedArtist == null) {
      return;
    }

    // Handles artist deletion
    if (editedRemovedArtist is bool && editedRemovedArtist) {
      setState(() {
        _artists = _artists.where((item) => item.id != artist.id).toList();
      });
      return;
    }

    // Handles artist edition
    final oldArtistIndex = _artists.indexWhere(
      (item) => item.id == editedRemovedArtist.id,
    );

    setState(() {
      _artists[oldArtistIndex] = editedRemovedArtist;
    });
  }

  Widget _renderArtists() {
    if (_isLoadingArtists) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isLoadingArtistsError != null) {
      return Center(child: Text(_isLoadingArtistsError!));
    }

    if (_artists.isEmpty) {
      return const Center(child: Text("Não há artistas cadastrados"));
    }

    final sortedArtists = _artists;
    sortedArtists.sort((a, b) => a.name.compareTo(b.name));

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: sortedArtists.length,
      itemBuilder: (context, index) {
        final artist = sortedArtists[index];
        return ArtistItem(
          artist: artist,
          onTap: () => _handleArtistEditDelete(artist),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadArtists,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Artistas", style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => _handleArtistAdd(),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _renderArtists(),
            ),
          ],
        ),
      ),
    );
  }
}
