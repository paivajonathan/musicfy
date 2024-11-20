import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/formatters.dart';
import 'package:trabalho1/models/artist.dart';

class TitleImage extends StatelessWidget {
  const TitleImage({
    super.key,
    required this.artist,
    required this.isHeader,
  });

  final Artist artist;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final height = isHeader ? 250.0 : 200.0;

    return Stack(
      children: [
        FadeInImage.assetNetwork(
          placeholder: "assets/loading.gif",
          image: artist.imageUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/placeholder.png",
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        ),
        Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(.75),
          alignment: isHeader
            ? Alignment.bottomLeft
            : Alignment.center,
          padding: const EdgeInsets.all(20),
          child: isHeader
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${formatNumber(artist.followers)} seguidores",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                artist.name,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
        )
      ],
    );
  }
}
