import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mensagem.dart';

class MensagensChat extends StatelessWidget {
  final String chatId;

  const MensagensChat({Key? key, required this.chatId}) : super(key: key);

  Future<String> _buscarNomeUsuario(String emailUsuario) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: emailUsuario)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['usuario'];
    }

    return 'Usuário desconhecido';
  }

  void _editarMensagem(String messageId, String novoTexto) async {
    await FirebaseFirestore.instance
        .collection('salas-participantes')
        .doc(chatId)
        .collection('mensagens')
        .doc(messageId)
        .update({
      'texto': novoTexto,
      'editada': true,
    });
  }

  void _excluirMensagem(String messageId) async {
    await FirebaseFirestore.instance
        .collection('salas-participantes')
        .doc(chatId)
        .collection('mensagens')
        .doc(messageId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('salas-participantes')
          .doc(chatId)
          .collection('mensagens')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Nenhuma mensagem enviada!', style: TextStyle(color: Colors.white),),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Algum erro desconhecido ocorreu'),
          );
        }

        final mensagensCarregadas = snapshot.data!.docs;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: mensagensCarregadas.length,
              itemBuilder: (context, index) {
                final mensagem = mensagensCarregadas[index];
                final messageId = mensagem.id;
                final conteudoMensagem = mensagem['texto'];
                final emailUsuario = mensagem['usuario'];
                final timestamp = mensagem['timestamp'];
                
                // Verifica se o campo 'editada' existe no documento
                final editada = mensagem.data() != null &&
                    (mensagem.data()! as Map<String, dynamic>).containsKey('editada') &&
                    mensagem['editada'] as bool;

                // Formate a data e hora para o formato padrão brasileiro
                final dataHoraFormatada =
                    DateFormat('dd/MM/yyyy HH:mm').format(
                        (timestamp as Timestamp).toDate());

                return FutureBuilder(
                  future: _buscarNomeUsuario(emailUsuario),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            'Erro ao carregar o nome do usuário'),
                      );
                    }

                    final nomeUsuario =
                        snapshot.data ?? 'Usuário desconhecido';
                    final isMe = currentUser?.email == emailUsuario;

                    return Mensagem(
                      conteudoMensagem: conteudoMensagem,
                      nomeUsuario: nomeUsuario,
                      dataHora: dataHoraFormatada,
                      isMe: isMe,
                      editada: editada,
                      onExcluir: () {
                        _excluirMensagem(messageId);
                      },
                      onEditar: (novoTexto) {
                        _editarMensagem(messageId, novoTexto);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
