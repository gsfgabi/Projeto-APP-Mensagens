import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a biblioteca intl para formatação de data e hora

import 'mensagem.dart';

class MensagensChat extends StatelessWidget {
  final String chatId;
  const MensagensChat({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Text('Nenhuma mensagem enviada!'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Algum erro desconhecido ocorreu'),
          );
        }

        final mensagensCarregadas = snapshot.data!.docs;

        print('Mensagens carregadas: $mensagensCarregadas');

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: mensagensCarregadas.length,
              itemBuilder: (context, index) {
                final mensagem = mensagensCarregadas[index];
                final conteudoMensagem = mensagem['texto'];
                final nomeUsuario = mensagem['usuario'];
                final timestamp = mensagem['timestamp'];
                
                // Formate a data e hora para o formato padrão brasileiro
                final dataHoraFormatada = DateFormat('dd/MM/yyyy HH:mm').format((timestamp as Timestamp).toDate());

                return Mensagem(
                  conteudoMensagem: conteudoMensagem,
                  nomeUsuario: nomeUsuario,
                  dataHora: dataHoraFormatada,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
