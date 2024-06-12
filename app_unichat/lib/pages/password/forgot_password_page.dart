import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'confirmation_page.dart';

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
    try {
      if (email.contains('unicv.edu.br')) {
        await _firebaseAuth.sendPasswordResetEmail(
          email: emailController.text,
        );

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ConfirmationPage()),
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
        title: SizedBox(
          width: 100,
          height: 50,
          child: Image.asset('assets/images/logounicvbranco.png'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 60),
            const SizedBox(height: 20),
            const Text(
              "Esqueceu a senha?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Digite o seu e-mail no campo abaixo.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (text) {
                setState(() {
                  email = text;
                });
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                labelText: "email@unicv.edu.br",
                labelStyle: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF4B9460)),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email, color: Color(0xFF4B9460)),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: const Color(0xFF4B9460),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () => _resetPassword(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
