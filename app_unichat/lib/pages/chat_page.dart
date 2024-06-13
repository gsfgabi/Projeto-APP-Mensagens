import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import '../widgets/mensagens_chat.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String curso;

  const ChatPage({Key? key, required this.chatId, required this.curso})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _mensagemController = TextEditingController();
  bool _podeEnviarMensagem = false;

  @override
  void initState() {
    super.initState();
    _verificarPermissaoEnvio();
  }

  Future<void> _verificarPermissaoEnvio() async {
    final usuario = _firebaseAuth.currentUser;
    if (usuario != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      if (docSnapshot.exists) {
        final dadosUsuario = docSnapshot.data();
        if (dadosUsuario != null &&
            (dadosUsuario['isAdmin'] == true ||
                dadosUsuario['isProfessor'] == true ||
                dadosUsuario['isCoordenador'] == true)) {
          setState(() {
            _podeEnviarMensagem = true;
          });
        }
      }
    }
  }

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
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await _firebaseAuth.signOut();
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => const LoginPage()),
        //       );
        //     },
        //     icon: const Icon(Icons.exit_to_app),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MensagensChat(chatId: widget.chatId),
          ),
          if (_podeEnviarMensagem)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: _mensagemController,
                      decoration: const InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF4B9460), width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
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
