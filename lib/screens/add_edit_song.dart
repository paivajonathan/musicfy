import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:trabalho1/models/song.dart';

class AddEditSongScreen extends StatefulWidget {
  const AddEditSongScreen({
    super.key,
    required this.artistId,
    this.songData,
  });

  final String artistId;
  final SongModel? songData;

  @override
  State<AddEditSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddEditSongScreen> {
  final _formKey = GlobalKey<FormState>();

  late var _enteredTitle =
      widget.songData != null ? widget.songData!.title : "";
  late var _enteredStreamsCount =
      widget.songData != null ? widget.songData!.streamsCount : 0;

  bool _isButtonLoading = false;

  Future<void> _saveSong() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final getSongsResponse = await http.get(url);

      if (getSongsResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao adicionar a música.",
              ),
            ),
          );
      }

      final getSongsResponseData = json.decode(getSongsResponse.body);

      for (final item in (getSongsResponseData ?? {}).entries) {
        if (item.value["title"] == _enteredTitle) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  "Já existe uma outra música com esse nome.",
                ),
              ),
            );

          return;
        }
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredTitle,
            'streamsCount': _enteredStreamsCount,
            'artistId': widget.artistId,
          },
        ),
      );

      final data = json.decode(response.body);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
            const SnackBar(content: Text("Música adicionada com sucesso.")));

      Navigator.of(context).pop(
        SongModel(
          id: data["name"],
          title: _enteredTitle,
          streamsCount: _enteredStreamsCount,
          artistId: widget.artistId,
          favoritedBy: [],
        ),
      );
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
            content: Text(e.toString().replaceAll("Exception: ", "")),
          ),
        );
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _editSong() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final getSongsUrl = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final getSongsResponse = await http.get(getSongsUrl);

      if (getSongsResponse.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro inesperado ao editar a música.",
              ),
            ),
          );
      }

      final getSongsResponseData = json.decode(getSongsResponse.body);

      for (final item in (getSongsResponseData ?? {}).entries) {
        if (item.value["title"] == _enteredTitle &&
            item.key != widget.songData!.id) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  "Já existe uma outra música com esse nome.",
                ),
              ),
            );

          return;
        }
      }

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs/${widget.songData!.id}.json',
      );

      await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredTitle,
            'streamsCount': _enteredStreamsCount,
            'artistId': widget.artistId,
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Informações da música editadas com sucesso."),
          ),
        );

      Navigator.of(context).pop(
        SongModel(
          id: widget.songData!.id,
          title: _enteredTitle,
          streamsCount: _enteredStreamsCount,
          artistId: widget.artistId,
          favoritedBy: widget.songData!.favoritedBy,
        ),
      );
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
            content: Text(e.toString().replaceAll("Exception: ", "")),
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
          title: widget.songData != null
              ? const Text("Editar Música")
              : const Text("Adicionar Música"),
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
                      label: Text('Título'),
                    ),
                    initialValue: _enteredTitle,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 50) {
                        return 'Deve ter entre 1 e 50 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredTitle = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      label: Text('Cont. de Streams'),
                    ),
                    initialValue: _enteredStreamsCount.toString(),
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
                      _enteredStreamsCount = int.parse(value!);
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
                        : widget.songData != null
                            ? () => _editSong()
                            : () => _saveSong(),
                    child: _isButtonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : widget.songData != null
                            ? const Text('Editar')
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
