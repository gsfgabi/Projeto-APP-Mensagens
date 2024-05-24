//import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({super.key});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  String nomecompleto = '';
  String email = '';
  String senha = '';
  String selecionarcurso = '';
  String codigoturma = '';
  final _chaveForm = GlobalKey<FormState>();

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
              key: _chaveForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Cadastro do Aluno',
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
                        nomecompleto = text;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null ||
                            valor.trim().isEmpty ) {
                          return 'Por favor, insira um nome válido!';
                        }
                        return null;
                      },
                      onSaved: (valorDigitado) {
                        if (valorDigitado != null) {
                          nomecompleto = valorDigitado;
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
                      ),
                      validator: (valor) {
                        if (valor == null ||
                            valor.trim().isEmpty ||
                            !valor.contains('@unicv.edu.br')) {
                          return 'Por favor, insira um endereço de email válido!';
                        }
                        return null;
                      },
                      onSaved: (valorDigitado) {
                        if (valorDigitado != null) {
                          email = valorDigitado;
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres.';
                        }
                        return null;
                      },
                      onSaved: (valor) {
                        if (valor != null) {
                          senha = valor;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      onChanged: (text) {
                        selecionarcurso = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Selecionar Curso',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      onChanged: (text) {
                        codigoturma = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Codigo da Turma',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B9460)
                        // Text Color (Foreground color)
                        ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (!_chaveForm.currentState!.validate()) {
                        return;
                      }
                      _chaveForm.currentState!.save();

                      if (email == email && senha == senha) {
                        try {
                          if (email.toLowerCase() == 'admin' &&
                            senha.toLowerCase() == 'admin') {
                            // Redireciona para a criação de uma conta como professor
                            Navigator.of(context).pushNamed('/RegisterTeacher');
                          } else {
                            // Verifica se o email e a senha foram fornecidos
                            if (email.isNotEmpty && senha.isNotEmpty) {
                              // Verifica se o email é válido
                              if (email.contains('@unicv.edu.br')) {
                                // Se todas as condições forem atendidas, redireciona para a tela de chat
                                final credenciaisUsuario =
                                              await _firebaseAuth
                                                  .createUserWithEmailAndPassword(
                                                      email: email,
                                                      password: senha);

                                                    await FirebaseFirestore.instance.collection('usuarios').doc(credenciaisUsuario.user!.uid).set({
                                                      'email' : email,
                                                      'isAdmin': false,
                                                      'usuario': nomecompleto,
                                                    });
                                Navigator.of(context)
                                  .pushReplacementNamed('/turma');
                              }
                            }else {
                              // Exibe uma mensagem de erro se o email ou senha estiverem vazios
                              print('Por favor, insira seu email e senha!');
                            }
                          }
                        } on FirebaseAuthException catch (error) {
                          String mensagem =
                              'Falha no cadastro de novo Usuário';
                          if (error.code ==
                              'email-already-in-use') {
                            mensagem = 'Email já utilizado';
                          }
                          ScaffoldMessenger.of(context)
                              .clearSnackBars();
                          ScaffoldMessenger.of(context)
                            .showSnackBar(
                            SnackBar(
                              content: Text(mensagem),
                            ),
                          );
                        }
                        // Navigator.of(context).pushReplacementNamed('/RegisterStudent');
                      
                      } else {
                        print('Login Invalido');
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        // Retornar à tela de login
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text(
                        'Já possui uma conta? Faça login',
                        style: TextStyle(color: Colors.blue),
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
