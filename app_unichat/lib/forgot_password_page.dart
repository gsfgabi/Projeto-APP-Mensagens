import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  String email = '';

  void _resetPassword(BuildContext context) async {
    try{
      if (email.contains('unicv.edu.br')) {
        await _firebaseAuth.sendPasswordResetEmail(
          email: emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email enviado com sucesso! Verifique sua cx de entrada.'),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      String message = 'Falha na redefinição de senha';
      if (error.code == 'user-not-found') {
        message = 'Email não cadastrado.';
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9460),
        title: const Text(
          'Esqueci a Senha',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
        body: Container(
          padding: const EdgeInsets.only(
            top: 60,
            left: 40,
            right: 40,
          ),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/reset-password-icon.png"),
              ),
              const SizedBox(height: 20,),
              const Text(
                "Esqueceu a senha?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Informe o email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              TextFormField(
                onChanged: (text) {
                  email = text;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty ||
                      !valor.contains('unicv.edu.br')) {
                    return 'Por favor, insira um endereço de email válido!';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B9460),
                    // Cor de Texto (Cor de primeiro plano)
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _resetPassword(context),
                ),
              ]),
            ],
          ),
        ),
      // body: Center(
      //   child: Card(
      //     elevation: 4,
      //     margin: const EdgeInsets.all(16),
      //     child: Padding(
      //       padding: const EdgeInsets.all(16),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Icon(Icons.warning,
      //               size: 50, color: Colors.red), // Ícone de alerta
      //           const SizedBox(height: 16),
      //           const Text(
      //             'Entre em Contato com o Suporte',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(fontSize: 20),
      //           ),
      //           const SizedBox(height: 16),
      //           const Text(
      //             'Para redefinir sua senha, entre em contato com nosso suporte em support@example.com.',
      //             textAlign: TextAlign.center,
      //           ),
      //           const SizedBox(height: 16),
      //           ElevatedButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.white, // Cor do botão
      //             ),
      //             child: const Text(
      //               'OK',
      //               style: TextStyle(color:  Color(0xFF4B9460)),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
