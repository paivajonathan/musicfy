import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/models/song.dart';

class FavoriteSongsNotifier extends StateNotifier<List<SongModel>> {
  FavoriteSongsNotifier() : super([]);

  bool isFavorite(SongModel song) {
    return (state.indexWhere((favoriteSong) => favoriteSong.id == song.id) != -1);
  }

  void addSongs(List<SongModel> songs) {
    state = [...state, ...songs];
  }

  void addSong(SongModel song) {
    state = [...state, song];
  }

  void updateSong(SongModel updatedSong) {
    state = state.map((song) {
      return song.id == updatedSong.id ? updatedSong : song;
    }).toList();
  }

  void removeSong(SongModel songToRemove) {
    state = state.where((song) => song.id != songToRemove.id).toList();
  }

  void removeSongs() {
    state = [];
  }
}

final favoriteSongsProvider =
    StateNotifierProvider<FavoriteSongsNotifier, List<SongModel>>((ref) {
  return FavoriteSongsNotifier();
});
