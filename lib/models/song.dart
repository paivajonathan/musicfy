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
}
