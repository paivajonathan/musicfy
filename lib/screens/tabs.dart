import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/providers/user_data.dart';
import 'package:trabalho1/screens/about.dart';
import 'package:trabalho1/screens/artists.dart';
import 'package:trabalho1/screens/favorite_songs.dart';
import 'package:trabalho1/widgets/main_drawer.dart';
import 'package:trabalho1/widgets/tabs_bottom_navigation.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _activeNavigationScreenIndex = 0;
  final List<Widget> _navigationScreens = [
    const ArtistsScreen(),
    const FavoriteSongsScreen(),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Musicfy"),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: MainDrawer(
        onSelectedScreen: (identifier) {
          _selectDrawerScreen(context, identifier);
        },
      ),
      body: _navigationScreens[_activeNavigationScreenIndex],
      bottomNavigationBar: TabsBottomNavigation(
        currentIndex: _activeNavigationScreenIndex,
        onTap: _selectNavigationScreen,
      ),
    );
  }
}
