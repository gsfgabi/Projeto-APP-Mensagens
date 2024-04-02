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
        mensagens: {'conteudo': 'Olá'},
      ),
    );
    listaChats.add(
      Chat(
        nome: '5º Análise e Desenvolvimento de Sistemas',
        mensagens: {'conteudo': 'Alô'},
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
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(listaChats[index].nome),
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

  Chat({required this.nome, required this.mensagens});
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
