import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool permitirNotificacoes = true; // Valor inicial para as notificações

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificações'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Permitir Notificações'),
          value: permitirNotificacoes,
          onChanged: (value) {
            setState(() {
              permitirNotificacoes = value;
              // Salve a preferência do usuário para notificações
              // Você pode usar SharedPreferences, banco de dados ou qualquer outro mecanismo de armazenamento
            });
          },
        ),
      ),
    );
  }
}
