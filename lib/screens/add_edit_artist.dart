import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:trabalho1/models/artist.dart';

class AddEditArtistScreen extends StatefulWidget {
  const AddEditArtistScreen({super.key, this.artistData});

  final ArtistModel? artistData;

  @override
  State<AddEditArtistScreen> createState() => _AddEditArtistScreenState();
}

class _AddEditArtistScreenState extends State<AddEditArtistScreen> {
  final _formKey = GlobalKey<FormState>();

  late var _enteredName =
      widget.artistData != null ? widget.artistData!.name : "";
  late var _enteredDescription =
      widget.artistData != null ? widget.artistData!.description : "";
  late var _enteredFollowersQuantity =
      widget.artistData != null ? widget.artistData!.followers : 0;
  late var _enteredImageURL =
      widget.artistData != null ? widget.artistData!.imageUrl : "";

  bool _isButtonLoading = false;

  Future<void> _saveArtist() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

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

      final data = json.decode(response.body);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text("Artista adicionado com sucesso.")));

      Navigator.of(context).pop(ArtistModel(
        id: data["name"],
        name: _enteredName,
        imageUrl: _enteredImageURL,
        followers: _enteredFollowersQuantity,
        description: _enteredDescription,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _editArtist() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists/${widget.artistData!.id}.json',
      );

      await http.put(
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

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text("Informações do artista editadas com sucesso.")));

      Navigator.of(context).pop(ArtistModel(
        id: widget.artistData!.id,
        name: _enteredName,
        imageUrl: _enteredImageURL,
        followers: _enteredFollowersQuantity,
        description: _enteredDescription,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
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
          title: widget.artistData != null
              ? const Text("Editar Artista")
              : const Text("Adicionar Artista"),
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
                    initialValue: _enteredName,
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
                    maxLength: 500,
                    decoration: const InputDecoration(
                      label: Text('Descrição'),
                    ),
                    initialValue: _enteredDescription,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 500) {
                        return 'Deve ter entre 1 e 500 caracteres';
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
                    initialValue: _enteredImageURL,
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: _isButtonLoading
                        ? null
                        : widget.artistData != null
                            ? () => _editArtist()
                            : () => _saveArtist(),
                    child: _isButtonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : widget.artistData != null
                            ? const Text("Editar")
                            : const Text('Adicionar'),
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
