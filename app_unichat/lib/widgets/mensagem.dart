import 'package:flutter/material.dart';

class Mensagem extends StatelessWidget {
  final String conteudoMensagem;
  final String nomeUsuario;
  final String dataHora;
  final bool isMe;

  const Mensagem({
    super.key,
    required this.conteudoMensagem,
    required this.nomeUsuario,
    required this.dataHora,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            nomeUsuario,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isMe ? Colors.white : Colors.white,
            ),
          ),
        ),
        Container(
          margin: isMe
              ? const EdgeInsets.only(left: 50, right: 10, bottom: 4)
              : const EdgeInsets.only(left: 10, right: 50, bottom: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.green[100] : Colors.grey[300],
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                conteudoMensagem,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dataHora,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
