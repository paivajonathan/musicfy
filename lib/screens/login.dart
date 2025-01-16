import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trabalho1/helpers/validators.dart';
import 'package:trabalho1/models/user.dart';
import 'package:trabalho1/providers/user_data.dart';
import 'package:trabalho1/screens/register.dart';
import 'package:trabalho1/screens/tabs.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = "";
  var _enteredPassword = "";

  bool _isButtonLoading = false;
  bool _isGoogleButtonLoading = false;

  Future<void> _login() async {
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

      ref.read(userDataProvider.notifier).addUserData(
            UserModel(
              id: userCredential.user!.uid,
              email: userCredential.user!.email!,
              name: userCredential.user!.displayName ?? "Sem nome",
            ),
          );

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

      ref.read(userDataProvider.notifier).addUserData(
            UserModel(
              id: userCredential.user!.uid,
              email: userCredential.user!.email!,
              name: userCredential.user!.displayName!,
            ),
          );

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
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Senha'),
                    ),
                    initialValue: _enteredPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 50) {
                        return 'Deve ter entre 1 e 50 caracteres';
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
