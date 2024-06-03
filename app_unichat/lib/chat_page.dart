import 'package:flutter/material.dart';
import 'widgets/mensagens_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String curso;
  const ChatPage({super.key, required this.chatId, required this.curso});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9460),
        title: Text(
          widget.curso,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              await _firebaseAuth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Column(
        children: [
          MensagensChat(
            chatId: widget.chatId,
          ),
        ],
      ),
    );
  }
}