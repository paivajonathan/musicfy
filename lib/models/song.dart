class Song {
  Song({
    required this.id,
    required this.title,
    required this.streamsCount,
    required this.artists,
    required this.artistsNames,
  });

  int id;
  String title;
  int streamsCount;
  List<int> artists;
  List<String> artistsNames;
}
