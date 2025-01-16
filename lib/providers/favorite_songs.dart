import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/models/song.dart';

class FavoriteSongsNotifier extends StateNotifier<List<SongModel>> {
  FavoriteSongsNotifier() : super([]);

  void toggleSongFavoriteStatus(SongModel song) {
    final mealIsFavorite = state.contains(song);

    if (mealIsFavorite) {
      state = state.where((s) => s.id != song.id).toList();
    } else {
      state = [...state, song];
    }
  }

  bool isFavorite(SongModel song) {
    return state.contains(song);
  }

  void updateSong(SongModel updatedSong) {
    state = state.map((song) {
      return song.id == updatedSong.id ? updatedSong : song;
    }).toList();
  }

  void updateArtistName(String artistId, String newArtistName) {
    state = state.map((song) {
      if (song.artistId == artistId) {
        return song.copyWith(artistName: newArtistName);
      }
      return song;
    }).toList();
  }

  void removeSong(SongModel songToRemove) {
    state = state.where((song) => song.id != songToRemove.id).toList();
  }
}

final favoriteSongsProvider =
    StateNotifierProvider<FavoriteSongsNotifier, List<SongModel>>((ref) {
  return FavoriteSongsNotifier();
});
