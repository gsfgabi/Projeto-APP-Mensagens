import 'package:cloud_functions/cloud_functions.dart';
import 'package:curso_flutter_flutterando/firebase/funcoes.dart';
import 'package:flutter/material.dart';

class RegisterCoordinator extends StatefulWidget {
  const RegisterCoordinator({super.key});

  @override
  State<RegisterCoordinator> createState() => _RegisterCoordinatorState();
}

class _RegisterCoordinatorState extends State<RegisterCoordinator> {
  String nomeCompleto = '';
  String email = '';
  String senha = '';
  String convite = '';
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNodeNomeCompleto = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeSenha = FocusNode();
  final FocusNode _focusNodeConvite = FocusNode();

  @override
  void dispose() {
    _focusNodeNomeCompleto.dispose();
    _focusNodeEmail.dispose();
    _focusNodeSenha.dispose();
    _focusNodeConvite.dispose();
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
          child: SingleChildScrollView( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Cadastro do Coordenador',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  // child: TextFormField(
                  //   onChanged: (text) {
                  //     setState(() {
                  //       nomeCompleto = text.toUpperCase(); // Convertendo para maiúsculas
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
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return 'Por favor, insira um nome válido!';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     if (value != null) {
                  //       nomeCompleto = value.toUpperCase(); // Convertendo para maiúsculas
                  //     }
                  //   },
                  // ),

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
                  // child: TextFormField(
                  //   onChanged: (text) {
                  //     email = text;
                  //   },
                  //   keyboardType: TextInputType.emailAddress,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Email',
                  //     border: OutlineInputBorder(),
                  //     focusedBorder: const OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Color(0xFF4B9460),
                  //       ),
                  //     ),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null ||
                  //         value.trim().isEmpty ||
                  //         !value.contains('unicv.edu.br')) {
                  //       return 'Por favor, insira um endereço de email válido!';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     if (value != null) {
                  //       email = value;
                  //     }
                  //   },
                  // ),

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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  // child: TextFormField(
                  //   onChanged: (text) {
                  //     senha = text;
                  //   },
                  //   obscureText: _obscureText,
                  //   decoration: InputDecoration(
                  //   labelText: 'Senha',
                  //   border: const OutlineInputBorder(),
                  //   focusedBorder: const OutlineInputBorder(
                  //     borderSide: BorderSide(
                  //       color: Color(0xFF4B9460),
                  //     ),
                  //   ),
                  //   suffixIcon: IconButton(
                  //     icon: Icon(
                  //       _obscureText
                  //           ? Icons.visibility
                  //           : Icons.visibility_off,
                  //       color:  const Color(0xFF4B9460),
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         _obscureText = !_obscureText;
                  //       });
                  //     },
                  //   ),
                  // ),
                  //   validator: (value) {
                  //     if (value == null || value.trim().length < 6) {
                  //       return 'A senha deve ter pelo menos 6 caracteres.';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     if (value != null) {
                  //       senha = value;
                  //     }
                  //   },
                  // ),

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
                  child: Focus(
                  focusNode: _focusNodeConvite,
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        onChanged: (text) {
                          convite = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Código de convite',
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
                            return 'Informe o convite da coordenação.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          convite = value ?? '';
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
                          await FuncoesUnichat.criarContaEquipe(
                            email: email,
                            password: senha,
                            nome: nomeCompleto,
                            papel: 'coordenador',
                            convite: convite,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cadastro realizado com sucesso!'),
                            ),
                          );

                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      }
                    } on FirebaseFunctionsException catch (error) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.message ?? 'Falha no cadastro de novo coordenador',
                          ),
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
                    // Redireciona para a tela de login
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
      ),
    );
  }
}
