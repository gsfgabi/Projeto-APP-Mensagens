import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  String nomeCompleto = '';
  String email = '';
  String senha = '';
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNodeNomeCompleto = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeSenha = FocusNode();

  @override
  void dispose() {
    _focusNodeNomeCompleto.dispose();
    _focusNodeEmail.dispose();
    _focusNodeSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9460),
        title: SizedBox(
          width: 100,
          height: 50,
          child: Image.asset('assets/images/logounicvbranco.png'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cadastro de Docente',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Focus(
                  focusNode: _focusNodeNomeCompleto,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        onChanged: (text) {
                          nomeCompleto = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          labelStyle: TextStyle(
                            color: isFocused ? Color(0xFF4B9460) : Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B9460),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira um nome válido!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            nomeCompleto = value.toUpperCase();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Focus(
                  focusNode: _focusNodeEmail,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        onChanged: (text) {
                          email = text;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: isFocused ? Color(0xFF4B9460) : Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B9460),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('unicv.edu.br')) {
                            return 'Por favor, insira um endereço de email válido!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            email = value;
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Focus(
                  focusNode: _focusNodeSenha,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        onChanged: (text) {
                          senha = text;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            color: isFocused ? Color(0xFF4B9460) : Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B9460),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF4B9460),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            senha = value;
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B9460),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();

                  try {
                    if (email.isNotEmpty && senha.isNotEmpty) {
                      if (email.contains('unicv.edu.br')) {
                        final credentials =
                            await _firebaseAuth.createUserWithEmailAndPassword(
                          email: email,
                          password: senha,
                        );

                        await FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(credentials.user!.uid)
                            .set({
                          'email': email,
                          'usuario': nomeCompleto.toUpperCase(),
                          'isProfessor': true,
                          'isCoordenador': false,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cadastro feito com sucesso!'),
                          ),
                        );

                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    } else {
                      print('Por favor, insira seu email e senha!');
                    }
                  } on FirebaseAuthException catch (error) {
                    String message = 'Falha no cadastro de novo docente';
                    if (error.code == 'email-already-in-use') {
                      message = 'Email já utilizado';
                    }
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text(
                  'Já possui uma conta? Faça login',
                  style: TextStyle(color: Color(0xFF4B9460)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
