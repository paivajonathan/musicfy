import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:trabalho1/models/song.dart';

class AddEditSongScreen extends StatefulWidget {
  const AddEditSongScreen({
    super.key,
    required this.artistId,
    required this.artistName,
    this.songData,
  });

  final String artistId;
  final String artistName;
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
            'artistName': widget.artistName,
          },
        ),
      );

      final data = json.decode(response.body);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text("Música adicionada com sucesso.")));

      Navigator.of(context).pop(
        SongModel(
          id: data["name"],
          title: _enteredTitle,
          streamsCount: _enteredStreamsCount,
          artistId: widget.artistId,
          artistName: widget.artistName,
        ),
      );
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

  Future<void> _editSong() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs/${widget.songData!.id}.json',
      );

      await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredTitle,
            'streamsCount': _enteredStreamsCount,
            'artistId': widget.artistId,
            'artistName': widget.artistName,
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text("Informações da música editadas com sucesso.")));

      Navigator.of(context).pop(
        SongModel(
          id: widget.songData!.id,
          title: _enteredTitle,
          streamsCount: _enteredStreamsCount,
          artistId: widget.artistId,
          artistName: widget.artistName,
        ),
      );
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
          title: widget.songData != null
              ? const Text("Editar Música")
              : const Text("Editar Música"),
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
