import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/models/user.dart';
import 'package:trabalho1/providers/user_data.dart';
import 'package:trabalho1/screens/login.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({
    super.key,
    required this.onSelectedScreen,
  });

  final void Function(String identifier) onSelectedScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch<UserModel?>(userDataProvider);

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(20)),
            ),
            child: Center(child: Text(userData!.name)),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 26,
            ),
            title:
                Text("Inicial", style: Theme.of(context).textTheme.titleLarge!),
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
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            onTap: () {
              onSelectedScreen("sobre");
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 26,
            ),
            title: Text(
              "Sair",
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pop();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
