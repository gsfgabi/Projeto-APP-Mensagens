import 'home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 300,
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
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
                    decoration: InputDecoration(
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
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    onChanged: (text) {
                      senha = text;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null ||
                          valor.trim().length < 6) {
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
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4B9460)
                      // Text Color (Foreground color)
                      ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (email.toLowerCase() == 'admin' &&
                        senha.toLowerCase() == 'admin') {
                      // Aqui você pode redirecionar a pessoa para criar uma conta como professor
                      // Por exemplo:
                      Navigator.of(context)
                          .pushReplacementNamed('/RegisterTeacher');
                    } else {
                      // Aqui você pode lidar com outras condições de login
                      if (email == email && senha == senha) {
                        Navigator.of(context).pushReplacementNamed('/chat');
                      } else {
                        print('Login Inválido');
                      }
                    }
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navegar para a página "Esqueci a Senha" aqui
                        Navigator.pushNamed(context, '/esqueciSenha');
                      },
                      child: Text(
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
                      child: Text(
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
        ],
      ),
    ));
  }
}
