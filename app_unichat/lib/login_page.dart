import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String senha = '';
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
          Card(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _chaveForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
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
                          email = text;
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null ||
                              valor.trim().isEmpty ||
                              !valor.contains('@')) {
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B9460),
                        // Cor de Texto (Cor de primeiro plano)
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (email.toLowerCase() == 'admin' &&
                            senha.toLowerCase() == 'admin') {
                          // Redireciona para a criação de uma conta como professor
                          Navigator.of(context).pushNamed('/RegisterTeacher');
                        } else {
                          // Verifica se o email e a senha correspondem a algum critério
                          if (email.isNotEmpty && senha.isNotEmpty) {
                            // Verifica se o email é válido
                            if (email.contains('@')) {
                              // Se todas as condições forem atendidas, redireciona para a tela de chat
                              Navigator.of(context)
                                  .pushReplacementNamed('/chat');
                            } else {
                              // Exibe uma mensagem de erro se o email for inválido
                              print(
                                  'Por favor, insira um endereço de email válido!');
                            }
                          } else {
                            // Exibe uma mensagem de erro se o email ou senha estiverem vazios
                            print('Por favor, insira seu email e senha!');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navegar para a página "Esqueci a Senha" aqui
                            Navigator.pushNamed(context, '/esqueciSenha');
                          },
                          child: const Text(
                            'Esqueci a Senha',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Color(0xFF4B9460)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navegar para a página "Primeiro Acesso" aqui
                            Navigator.pushNamed(context, '/RegisterStudent');
                          },
                          child: const Text(
                            'Primeiro Acesso',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Color(0xFF4B9460)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
