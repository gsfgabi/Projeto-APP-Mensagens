import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mensagens_chat.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String curso;

  const ChatPage({super.key, required this.chatId, required this.curso});

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
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: const Color(0xFF4B9460),
                title: Text(
                  widget.curso,
                  style: const TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
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
                          controller: _mensagemController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Digite uma mensagem...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.5),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF4B9460), width: 1.0),
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                        onPressed: _enviarMensagem,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
