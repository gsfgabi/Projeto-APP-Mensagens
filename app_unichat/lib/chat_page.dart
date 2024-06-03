import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'widgets/mensagens_chat.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String curso;

  const ChatPage({Key? key, required this.chatId, required this.curso}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _mensagemController = TextEditingController();

  void _enviarMensagem() {
    final usuario = _firebaseAuth.currentUser;
    if (usuario != null && _mensagemController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('salas-participantes')
          .doc(widget.chatId)
          .collection('mensagens')
          .add({
        'texto': _mensagemController.text,
        'usuario': usuario.email,
        'timestamp': Timestamp.now(),
      });
      _mensagemController.clear();
    }
  }

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
          Expanded(
            child: MensagensChat(chatId: widget.chatId),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mensagemController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _enviarMensagem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
