import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/constants.dart';
import 'package:trabalho1/screens/tabs.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TabsScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(kSeedColor),
        ),
      ),
    );
  }
}
