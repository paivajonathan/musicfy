import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class AddArtistScreen extends StatefulWidget {
  const AddArtistScreen({super.key});

  @override
  State<AddArtistScreen> createState() => _AddArtistScreenState();
}

class _AddArtistScreenState extends State<AddArtistScreen> {
  // name, description, followers, imageUrl

  final _formKey = GlobalKey<FormState>();

  var _enteredName = "";
  var _enteredDescription = "";
  var _enteredFollowersQuantity = 0;
  var _enteredImageURL = "";

  Future<void> _saveArtist() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists.json',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'description': _enteredDescription,
            'followersQuantity': _enteredFollowersQuantity,
            'imageURL': _enteredImageURL,
          },
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Artista"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 50) {
                        return 'Deve ter entre 1 e 50 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  TextFormField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                      label: Text('Descrição'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 100) {
                        return 'Deve ter entre 1 e 100 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredDescription = value!;
                    },
                  ),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      label: Text('Qtd. de seguidores'),
                    ),
                    initialValue: _enteredFollowersQuantity.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Deve ser maior que 0';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredFollowersQuantity = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    maxLength: 300,
                    decoration: const InputDecoration(
                      label: Text('URL da Imagem'),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 300) {
                        return 'Deve ter entre 1 e 300 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredImageURL = value!;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _saveArtist(),
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
