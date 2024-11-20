import 'package:flutter/material.dart';
import 'package:trabalho1/models/artist.dart';
import 'package:trabalho1/screens/artist_details.dart';
import 'package:trabalho1/widgets/title_image.dart';

class ArtistItem extends StatelessWidget {
  const ArtistItem({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArtistDetailsScreen(artist: artist)
            )
          );
        },
        child: TitleImage(artist: artist),
      ),
    );
  }
}
