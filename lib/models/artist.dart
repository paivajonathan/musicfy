class ArtistModel {
  ArtistModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.followers,
    required this.description,
  });

  String id;
  String name;
  String imageUrl;
  int followers;
  String description;
}
