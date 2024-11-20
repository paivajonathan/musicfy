import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.waves),
        const SizedBox(width: 10),
        Text(
          "Musicfy",
          style: Theme.of(context).textTheme.headlineLarge!
        ),
      ],
    );
  }
}
