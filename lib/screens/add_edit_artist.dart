import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:trabalho1/helpers/validators.dart';
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
  late var _enteredImageUrl =
      widget.artistData != null ? widget.artistData!.imageUrl : "";

  bool _isButtonLoading = false;

  Future<void> _saveArtist() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final isImageValid = await isImageUrlValid(_enteredImageUrl);

    if (!isImageValid) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "URL não é uma imagem válida. Tente novamente.",
            ),
          ),
        );

      return;
    }

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists.json',
      );

      final getArtistsResponse = await http.get(url);

      if (getArtistsResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao adicionar um artista.",
              ),
            ),
          );
      }

      final getArtistsResponseData = json.decode(getArtistsResponse.body);

      for (final item in (getArtistsResponseData ?? {}).entries) {
        if (item.value["name"] == _enteredName) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  "Já existe um outro artista com esse nome.",
                ),
              ),
            );

          return;
        }
      }

      final createUserResponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'description': _enteredDescription,
            'followersQuantity': _enteredFollowersQuantity,
            'imageUrl': _enteredImageUrl,
          },
        ),
      );

      if (createUserResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao adicionar um artista.",
              ),
            ),
          );
      }

      final data = json.decode(createUserResponse.body);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Artista adicionado com sucesso.",
            ),
          ),
        );

      Navigator.of(context).pop(ArtistModel(
        id: data["name"],
        name: _enteredName,
        imageUrl: _enteredImageUrl,
        followers: _enteredFollowersQuantity,
        description: _enteredDescription,
      ));
    } on http.ClientException catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Verifique a sua conexão com a internet."),
          ),
        );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
          ),
        );
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _editArtist() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final isImageValid = await isImageUrlValid(_enteredImageUrl);

    if (!isImageValid) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "URL não é uma imagem válida. Tente novamente.",
            ),
          ),
        );

      return;
    }

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final getArtistsUrl = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists.json',
      );

      final getArtistsResponse = await http.get(getArtistsUrl);

      if (getArtistsResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao adicionar um artista.",
              ),
            ),
          );
      }

      final getArtistsResponseData = json.decode(getArtistsResponse.body);

      for (final item in (getArtistsResponseData ?? {}).entries) {
        if (item.value["name"] == _enteredName &&
            item.key != widget.artistData!.id) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  "Já existe um outro artista com esse nome.",
                ),
              ),
            );

          return;
        }
      }

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'artists/${widget.artistData!.id}.json',
      );

      await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'description': _enteredDescription,
            'followersQuantity': _enteredFollowersQuantity,
            'imageUrl': _enteredImageUrl,
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Informações do artista editadas com sucesso.",
            ),
          ),
        );

      Navigator.of(context).pop(ArtistModel(
        id: widget.artistData!.id,
        name: _enteredName,
        imageUrl: _enteredImageUrl,
        followers: _enteredFollowersQuantity,
        description: _enteredDescription,
      ));
    } on http.ClientException catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Verifique a sua conexão com a internet."),
          ),
        );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
          ),
        );
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
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 300,
                    decoration: const InputDecoration(
                      label: Text('URL da Imagem'),
                    ),
                    initialValue: _enteredImageUrl,
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
                      _enteredImageUrl = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
