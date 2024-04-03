import 'package:flutter/material.dart';
import 'app_controller.dart';

class PaginaDeChats extends StatefulWidget {
  const PaginaDeChats({Key? key}) : super(key: key);

  @override
  State<PaginaDeChats> createState() => _PaginaDeChatsState();
}

class _PaginaDeChatsState extends State<PaginaDeChats> {
  final List<Chat> listaChats = [];

  @override
  void initState() {
    super.initState();
    adicionaNovoChat();
  }

  void adicionaNovoChat() {
    listaChats.add(
      Chat(
        nome: '5º Engenharia de Software',
        mensagens: {'conteudo': 'Atividade para entregar até amanhã'},
        imagem: 'assets/images/EWS.png',
      ),
    );
    listaChats.add(
      Chat(
        nome: '4º Análise e Desenvolvimento de Sistemas',
        mensagens: {'conteudo': 'Atividade está no LXP'},
        imagem: 'assets/images/ADS.png',
      ),
    );
    listaChats.add(
      Chat(
        nome: '3º Direito',
        mensagens: {'conteudo': 'Entregar relatório de estágio até amanhá'},
        imagem: 'assets/images/DIREITO.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // width: 200,
              // height: 100,
              child: Column(
                // Usamos Stack para sobrepor o texto e o botão
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100, right: 100),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Turmas',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF4B9460),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomSwitcher(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              key: GlobalKey(),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listaChats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(listaChats[index].nome),
                  subtitle: Text("Bacharel"),
                  hoverColor: Color.fromARGB(255, 68, 137, 87),
                  leading: Image.asset(
                    listaChats[index].imagem,
                  ),
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Chat {
  final String nome;
  final Map<String, String> mensagens;
  String imagem;

  Chat({required this.nome, required this.mensagens, required this.imagem});
}

class CustomSwitcher extends StatelessWidget {
  const CustomSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.darkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
      activeColor: Color(0xFF4B9460), // Definindo a cor do botão para verde
    );
  }
}
