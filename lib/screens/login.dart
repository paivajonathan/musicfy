import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trabalho1/helpers/validators.dart';
import 'package:trabalho1/models/song.dart';
import 'package:trabalho1/models/user.dart';
import 'package:trabalho1/providers/favorite_songs.dart';
import 'package:trabalho1/providers/user_data.dart';
import 'package:trabalho1/screens/register.dart';
import 'package:trabalho1/screens/tabs.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = "";
  var _enteredPassword = "";
  bool _isPasswordVisible = false;

  bool _isButtonLoading = false;
  bool _isGoogleButtonLoading = false;

  Future<void> _login() async {
    final userDataNotifier = ref.read(userDataProvider.notifier);
    final favoriteSongsNotifier = ref.read(favoriteSongsProvider.notifier);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final response = await http.get(url);

      if (response.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Ocorreu um erro inesperado ao realizar login."),
            ),
          );

        return;
      }

      final responseData = json.decode(response.body);

      List<SongModel> favoriteSongs = [];

      if (responseData != null) {
        for (final item in responseData.entries) {
          List<String> favoritedBy = [];

          for (final favoritedItem
              in (item.value["favoritedBy"] ?? {}).entries) {
            favoritedBy.add(favoritedItem.key);
          }

          if (!favoritedBy.contains(userCredential.user!.uid)) {
            continue;
          }

          favoriteSongs.add(SongModel(
            id: item.key,
            title: item.value["title"],
            streamsCount: item.value["streamsCount"],
            artistId: item.value["artistId"],
            favoritedBy: favoritedBy,
          ));
        }
      }

      userDataNotifier.addUserData(
        UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? "Sem nome",
        ),
      );

      favoriteSongsNotifier.addSongs(favoriteSongs);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const TabsScreen();
          },
        ),
      );
    } on FirebaseException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Não foi encontrado um usuário com esse email.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'network-request-failed':
          message = 'Por favor verifique a sua conexão com a internet.';
          break;
        default:
          message = 'Um erro inesperado ocorreu. Por favor, tente novamente.';
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
    } on Exception catch (e) {
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

  Future<void> _googleLogin() async {
    final userDataNotifier = ref.read(userDataProvider.notifier);
    final favoriteSongsNotifier = ref.read(favoriteSongsProvider.notifier);

    try {
      setState(() {
        _isGoogleButtonLoading = true;
      });

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final url = Uri.https(
        'musicfy-72db4-default-rtdb.firebaseio.com',
        'songs.json',
      );

      final response = await http.get(url);

      if (response.statusCode > 400) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Ocorreu um erro inesperado ao realizar login."),
            ),
          );

        return;
      }

      final responseData = json.decode(response.body);

      List<SongModel> favoriteSongs = [];

      if (responseData != null) {
        for (final item in responseData.entries) {
          List<String> favoritedBy = [];

          for (final favoritedItem
              in (item.value["favoritedBy"] ?? {}).entries) {
            favoritedBy.add(favoritedItem.key);
          }

          if (!favoritedBy.contains(userCredential.user!.uid)) {
            continue;
          }

          favoriteSongs.add(SongModel(
            id: item.key,
            title: item.value["title"],
            streamsCount: item.value["streamsCount"],
            artistId: item.value["artistId"],
            favoritedBy: favoritedBy,
          ));
        }
      }

      userDataNotifier.addUserData(
        UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName!,
        ),
      );

      favoriteSongsNotifier.addSongs(favoriteSongs);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const TabsScreen();
          },
        ),
      );
    } on Exception catch (e) {
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
        _isGoogleButtonLoading = false;
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
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    initialValue: _enteredEmail,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 100) {
                        return 'Deve ter entre 1 e 100 caracteres';
                      }

                      if (!isEmailValid(value)) {
                        return 'Email inválido';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredEmail = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: const Text('Senha'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    initialValue: _enteredPassword,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length < 8) {
                        return 'Deve ter pelo menos 8 caracteres.';
                      }

                      if (value.trim().length > 50) {
                        return 'Deve ter no máximo 50 caracteres';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredPassword = value!;
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
                    onPressed: _isButtonLoading ? null : () => _login(),
                    child: _isButtonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : const Text("Login"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("ou"),
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
                    onPressed:
                        _isGoogleButtonLoading ? null : () => _googleLogin(),
                    child: _isGoogleButtonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : const Text("Login com Google"),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const Text("Ainda não possui conta?"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
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
