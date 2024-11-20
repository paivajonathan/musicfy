import 'package:flutter/material.dart';
import 'package:trabalho1/widgets/app_logo.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectedScreen,
  });

  final void Function(String identifier) onSelectedScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20)
              ),
            ),
            child: const Center(
              child: AppLogo()
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 26,
            ),
            title: Text(
              "Inicial",
              style: Theme.of(context).textTheme.titleLarge!
            ),
            onTap: () {
              onSelectedScreen("inicial");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              size: 26,
            ),
            title: Text(
              "Sobre",
              style: Theme.of(context).textTheme.titleLarge!
            ),
            onTap: () {
              onSelectedScreen("sobre");
            },
          ),
        ],
      ),
    );
  }
}
