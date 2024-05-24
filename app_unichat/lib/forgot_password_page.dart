import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
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
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning,
                    size: 50, color: Colors.red), // Ícone de alerta
                const SizedBox(height: 16),
                const Text(
                  'Entre em Contato com o Suporte',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Para redefinir sua senha, entre em contato com nosso suporte em support@example.com.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Cor do botão
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color:  Color(0xFF4B9460)),
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
