import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho1/helpers/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredName = "";
  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredPasswordConfirmation = "";

  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;

  bool _isButtonLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isButtonLoading = true;
      });

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      if (userCredential.user == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Ocorreu um erro inesperado ao cadastrar a conta."),
            ),
          );

        return;
      }

      await userCredential.user!.updateDisplayName(_enteredName);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Conta cadastrada com sucesso.",
            ),
          ),
        );

      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      String message;

      switch (e.code) {
        case 'weak-password':
          message = 'A senha digitada é muito fraca.';
          break;
        case 'email-already-in-use':
          message = 'Já existe uma conta com esse email.';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastrar-se"),
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
                    maxLength: 100,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    initialValue: _enteredEmail,
                    keyboardType: TextInputType.emailAddress,
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
                        return 'Deve ter pelo menos 8 caracteres';
                      }

                      if (value.trim().length > 50) {
                        return 'Deve ter no máximo 50 caracteres';
                      }

                      if (value != _enteredPasswordConfirmation) {
                        return 'As senhas não coincidem';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      _enteredPassword = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: const Text('Confirmação de Senha'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordConfirmationVisible =
                                !_isPasswordConfirmationVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordConfirmationVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordConfirmationVisible,
                    initialValue: _enteredPasswordConfirmation,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length < 8) {
                        return 'Deve ter pelo menos 8 caracteres';
                      }

                      if (value.trim().length > 50) {
                        return 'Deve ter no máximo 50 caracteres';
                      }

                      if (value != _enteredPassword) {
                        return 'As senhas não coincidem';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      _enteredPasswordConfirmation = value;
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
                    onPressed: _isButtonLoading ? null : () => _register(),
                    child: _isButtonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Cadastrar-se"),
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
