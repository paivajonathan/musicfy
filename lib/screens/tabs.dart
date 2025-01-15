import 'package:flutter/material.dart';
import 'package:trabalho1/screens/about.dart';
import 'package:trabalho1/screens/add_artist.dart';
import 'package:trabalho1/screens/artists.dart';
import 'package:trabalho1/screens/ranking.dart';
import 'package:trabalho1/widgets/main_drawer.dart';
import 'package:trabalho1/widgets/tabs_bottom_navigation.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _activeNavigationScreenIndex = 0;

  void _selectDrawerScreen(BuildContext context, String identifier) {
    switch (identifier) {
      case "sobre":
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AboutScreen()));
      default:
        Navigator.of(context).pop();
    }
  }

  void _selectNavigationScreen(int index) {
    setState(() => _activeNavigationScreenIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _navigationScreens = [
      {
        "title": "Artistas",
        "content": const ArtistsScreen(),
        "actions": [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddArtistScreen()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      },
      {
        "title": "Ranking",
        "content": const RankingScreen(),
        "actions": null,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_navigationScreens[_activeNavigationScreenIndex]["title"]),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: _navigationScreens[_activeNavigationScreenIndex]["actions"],
      ),
      drawer: MainDrawer(
        onSelectedScreen: (identifier) {
          _selectDrawerScreen(context, identifier);
        },
      ),
      body: _navigationScreens[_activeNavigationScreenIndex]["content"],
      bottomNavigationBar: TabsBottomNavigation(
        currentIndex: _activeNavigationScreenIndex,
        onTap: _selectNavigationScreen,
      ),
    );
  }
}
