import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9460),
        title: Text(
          'Esqueci a Senha',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning,
                    size: 50, color: Colors.red), // Ícone de alerta
                SizedBox(height: 16),
                Text(
                  'Entre em Contato com o Suporte',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  'Para redefinir sua senha, entre em contato com nosso suporte em support@example.com.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Cor do botão
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(color: const Color(0xFF4B9460)),
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
