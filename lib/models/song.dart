class SongModel {
  SongModel({
    required this.id,
    required this.title,
    required this.streamsCount,
    required this.artistId,
    required this.favoritedBy,
  });

  String id;
  String title;
  int streamsCount;
  String artistId;
  List<String> favoritedBy;

  SongModel copyWith({
    String? id,
    String? title,
    int? streamsCount,
    String? artistId,
    List<String>? favoritedBy,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      streamsCount: streamsCount ?? this.streamsCount,
      artistId: artistId ?? this.artistId,
      favoritedBy: favoritedBy ?? this.favoritedBy,
    );
  }
}
