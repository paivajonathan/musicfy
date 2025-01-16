class SongModel {
  SongModel({
    required this.id,
    required this.title,
    required this.streamsCount,
    required this.artistId,
    required this.artistName,
  });

  String id;
  String title;
  int streamsCount;
  String artistId;
  String artistName;

  SongModel copyWith({
    String? id,
    String? title,
    int? streamsCount,
    String? artistId,
    String? artistName,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      streamsCount: streamsCount ?? this.streamsCount,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
    );
  }
}
