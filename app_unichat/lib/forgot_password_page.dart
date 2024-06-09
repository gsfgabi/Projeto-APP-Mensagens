import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  void _resetPassword(BuildContext context) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
    } catch (e) {
      print("Error: $e");
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
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
