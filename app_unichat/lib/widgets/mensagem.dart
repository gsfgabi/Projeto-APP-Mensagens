import 'package:flutter/material.dart';

class Mensagem extends StatelessWidget {
  final String conteudoMensagem;
  final String nomeUsuario;
  final String dataHora;
  final Color corTexto; 
  const Mensagem({
    Key? key,
    required this.conteudoMensagem,
    required this.nomeUsuario,
    required this.dataHora,
    required this.corTexto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            nomeUsuario,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: corTexto, 
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
