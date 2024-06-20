import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  String? selecionarcurso;
  String codigoturma = '';
  bool _obscureText = true;
  final _chaveForm = GlobalKey<FormState>();

  final FocusNode _nomeFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _senhaFocusNode = FocusNode();
  final FocusNode _codigoFocusNode = FocusNode();
  final FocusNode _turmaFocusNode = FocusNode();

  @override
  void dispose() {
    _nomeFocusNode.dispose();
    _emailFocusNode.dispose();
    _senhaFocusNode.dispose();
    _codigoFocusNode.dispose();
    _turmaFocusNode.dispose();
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                // child: TextFormField(
                //   focusNode: _nomeFocusNode,
                //   style: TextStyle(
                //     color: _nomeFocusNode.hasFocus
                //         ? const Color(0xFF4B9460)
                //         : Colors.black,
                //   ),
                //   onChanged: (text) {
                //     setState(() {
                //       nomecompleto = text.toUpperCase();
                //     });
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Nome Completo',
                //     border: OutlineInputBorder(),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Color(0xFF4B9460),
                //       ),
                //     ),
                //   ),
                //   validator: (valor) {
                //     if (valor == null || valor.trim().isEmpty) {
                //       return 'Por favor, insira um nome válido!';
                //     }
                //     return null;
                //   },
                //   onSaved: (valorDigitado) {
                //     if (valorDigitado != null) {
                //       nomecompleto = valorDigitado.toUpperCase();
                //     }
                //   },
                // ),
                child: Focus(
                  focusNode: _nomeFocusNode,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        onChanged: (text) {
                          setState(() {
                            nomecompleto = text.toUpperCase();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          labelStyle: TextStyle(
                            color: isFocused ? const Color(0xFF4B9460) : Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
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
                        onSaved: (valorDigitado) {
                          if (valorDigitado != null) {
                            nomecompleto = valorDigitado.toUpperCase();
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
                  focusNode: _emailFocusNode,
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
                            color: isFocused ? const Color(0xFF4B9460) : Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
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
                      );
                    },
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
              //   child: TextFormField(
              //     focusNode: _emailFocusNode,
              //     style: TextStyle(
              //       color: _emailFocusNode.hasFocus
              //           ? const Color(0xFF4B9460)
              //           : Colors.black,
              //     ),
              //     onChanged: (text) {
              //       setState(() {
              //         email = text;
              //       });
              //     },
              //     keyboardType: TextInputType.emailAddress,
              //     decoration: const InputDecoration(
              //       labelText: 'Email',
              //       labelStyle: TextStyle(
              //         color: isFocused ? const Color(0xFF4B9460) : Colors.grey,
              //       ),
              //       border: OutlineInputBorder(),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Color(0xFF4B9460),
              //         ),
              //       ),
              //     ),
              //     validator: (valor) {
              //       if (valor == null ||
              //           valor.trim().isEmpty ||
              //           !valor.contains('unicv.edu.br')) {
              //         return 'Por favor, insira um endereço de email válido!';
              //       }
              //       return null;
              //     },
              //     onSaved: (valorDigitado) {
              //       if (valorDigitado != null) {
              //         email = valorDigitado;
              //       }
              //     },
              //   ),
              // ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Focus(
                  focusNode: _senhaFocusNode,
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
                            color: isFocused ? const Color(0xFF4B9460) : Colors.grey,
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
                      Set<String> cursos = {};
                      for (var doc in snapshot.data!.docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        if (data.containsKey('nome')) {
                          String? nomeCurso = data['nome'];
                          if (nomeCurso != null) {
                            cursos.add(nomeCurso);
                          }
                        }
                      }

                      List<String> cursosList = cursos.toList();
                      cursosList.sort(); // Ordenando cursos em ordem crescente

                      return DropdownButtonFormField<String>(
                        value: selecionarcurso,
                        decoration: const InputDecoration(
                          labelText: 'Selecionar Curso',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B9460),
                            ),
                          ),
                        ),
                        items: cursosList.map((String value) {
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
                child: Focus(
                  focusNode: _codigoFocusNode,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                  onChanged: (text) {
                    setState(() {
                      codigoturma = text.toUpperCase();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Código da Turma',
                    labelStyle: TextStyle(
                      color: isFocused ? const Color(0xFF4B9460) : Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4B9460),
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Por favor, insira um código de turma válido!';
                    }
                    return null;
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
                  if (!_chaveForm.currentState!.validate()) {
                    return;
                  }

                  if (selecionarcurso == null || codigoturma.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Por favor, selecione um curso e insira o código da turma!'),
                      ),
                    );
                    return;
                  }

                  bool isTurmaValida = await verificarCodigoTurma();
                  if (isTurmaValida) {
                    await cadastrarUsuario();
                    await adicionarUsuarioNaTurma();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('O código da turma é inválido!'),
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

  Future<bool> verificarCodigoTurma() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('salas-participantes')
        .where('codigo', isEqualTo: codigoturma)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> cadastrarUsuario() async {
    try {
      final credenciaisUsuario =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credenciaisUsuario.user!.uid)
          .set({
        'email': email,
        'isAdmin': false,
        'isProfessor': false,
        'isCoordenador': false,
        'usuario': nomecompleto,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
        ),
      );

      Navigator.of(context).pushReplacementNamed('/login');
    } on FirebaseAuthException catch (error) {
      String message = 'Falha no cadastro de novo aluno';
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
  }

  Future<void> adicionarUsuarioNaTurma() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('salas-participantes')
        .where('codigo', isEqualTo: codigoturma)
        .get();

    String turmaId = querySnapshot.docs.first.id;

    await FirebaseFirestore.instance
        .collection('salas-participantes')
        .doc(turmaId)
        .update({
      'email': FieldValue.arrayUnion([email])
    });
  }
}
