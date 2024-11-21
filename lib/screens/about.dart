import 'package:flutter/material.dart';
import 'package:trabalho1/screens/tabs.dart';
import 'package:trabalho1/widgets/app_logo.dart';
import 'package:trabalho1/widgets/main_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _selectDrawerScreen(BuildContext context, String identifier) {
    switch (identifier) {
      case "inicial":
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabsScreen()
          )
        );
      default:
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: MainDrawer(
        onSelectedScreen: (identifier) {
          _selectDrawerScreen(context, identifier);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            const AppLogo(),
            const SizedBox(height: 20),
            Text(
              "A música que você busca, no lugar que você está.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!,
            ), 
            const SizedBox(height: 20),
            Text(
              "Versão",
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 20),
            Text(
              "1.0.0",
              style: Theme.of(context).textTheme.bodyLarge!,
            ),       
            const SizedBox(height: 20),
            Text(
              "Desenvolvido por",
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 20),
            Text(
              "Jonathan Araujo Paiva\nPatrine Silva Santos",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: 20),
            Text(
              "Curso",
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 20),
            Text(
              "Análise e Desenvolvimento de Sistemas",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),   
            const SizedBox(height: 20),
            Text(
              "Instituição",
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 20),
            Text(
              "Instituto Federal do Piauí - Campus Parnaíba",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: 20),    
            Text(
              "© 2024",
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ],
        ),
      )
    );
  }
}