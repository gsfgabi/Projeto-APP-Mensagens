import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({Key? key});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  String nomecompleto = '';
  String email = '';
  String senha = '';
  String? selecionarcurso; // Alterado para String nullable
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
                          if (valor == null || valor.trim().isEmpty) {
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('salas-participantes')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            List<String> cursos = [];
                            for (var doc in snapshot.data!.docs) {
                              var data = doc.data() as Map<String, dynamic>;
                              if (data.containsKey('nome')) {
                                String? nomeCurso = data['nome'];
                                if (nomeCurso != null) {
                                  cursos.add(nomeCurso);
                                }
                              }
                            }
                            return DropdownButtonFormField<String>(
                              value: selecionarcurso,
                              decoration: const InputDecoration(
                                labelText: 'Selecionar Curso',
                                border: OutlineInputBorder(),
                              ),
                              items: cursos.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selecionarcurso = value;
                                });
                              },
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Por favor, selecione um curso!';
                                }
                                return null;
                              },
                            );
                          }
                        },
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
                        backgroundColor: const Color(0xFF4B9460),
                      ),
                      onPressed: () async {
                        if (!_chaveForm.currentState!.validate()) {
                          return;
                        }
                        _chaveForm.currentState!.save();

                        if (email == 'admin' && senha == 'admin') {
                          Navigator.of(context)
                              .pushNamed('/RegisterTeacher');
                        } else {
                          if (email.isNotEmpty && senha.isNotEmpty) {
                            if (email.contains('@unicv.edu.br')) {
                              final credenciaisUsuario =
                                  await _firebaseAuth
                                      .createUserWithEmailAndPassword(
                                email: email,
                                password: senha,
                              );

                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(credenciaisUsuario.user!.uid)
                                  .set({
                                'email': email,
                                'isAdmin': false,
                                'usuario': nomecompleto,
                              });

                              Navigator.of(context)
                                  .pushReplacementNamed('/turma');
                            }
                          } else {
                            print('Por favor, insira seu email e senha!');
                          }
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
                        Navigator.of(context)
                            .pushReplacementNamed('/login');
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
