import 'package:flutter/material.dart';
import 'widgets/mensagens_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class PaginaDeChat extends StatefulWidget {
  const PaginaDeChat({super.key});

  @override
  State<PaginaDeChat> createState() => _PaginaDeChatState();
}

class _PaginaDeChatState extends State<PaginaDeChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          '5º ESW',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _firebaseAuth.signOut(),
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: const Column(
        children: [
          MensagensChat(),
        ],
      ),
    );
  }
}