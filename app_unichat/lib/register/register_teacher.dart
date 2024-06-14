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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
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
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        onChanged: (text) {
                          nomeCompleto = text;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                          border: OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
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
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        onChanged: (text) {
                          email = text;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
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
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        onChanged: (text) {
                          senha = text;
                        },
                        obscureText: _obscureText,
                    decoration: InputDecoration(
                    labelText: 'Senha',
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
                        color:  const Color(0xFF4B9460),
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
                          // Verifica se o email e a senha foram fornecidos
                          if (email.isNotEmpty && senha.isNotEmpty) {
                            // Verifica se o email é válido
                            if (email.contains('unicv.edu.br')) {
                              // Cadastra o usuário no banco de dados
                              final credentials =
                                  await _firebaseAuth.createUserWithEmailAndPassword(
                                email: email,
                                password: senha,
                              );

                              // Salva os dados do docente no Firestore
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(credentials.user!.uid)
                                  .set({
                                'email': email,
                                'usuario': nomeCompleto.toUpperCase(), // Salvando o nome em maiúsculas
                                'isProfessor': true,
                                'isCoordenador': false,
                              });

                              // Exibe a notificação de cadastro feito com sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cadastro feito com sucesso!'),
                                ),
                              );

                              // Redireciona para a tela de login após o cadastro
                              Navigator.of(context).pushReplacementNamed('/login');
                            }
                          } else {
                            // Exibe uma mensagem de erro se o email ou senha estiverem vazios
                            print('Por favor, insira seu email e senha!');
                          }
                        } on FirebaseAuthException catch (error) {
                          // Trata erros de autenticação
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
                        // Retornar à tela de login
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
          ],
        ),
      ),
    );
  }
}
