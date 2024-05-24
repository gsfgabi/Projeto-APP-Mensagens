import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_controller.dart';
import 'chat_page.dart';
import 'login_page.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    final usuarioAutenticado = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('salas-participantes')
          .where('email', arrayContains: usuarioAutenticado!.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return const Center(
        //     child: Text('Nenhuma sala encontrada!'),
        //   );
        // }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Algum erro desconhecido ocorreu'),
          );
        }

        final chatsCarregados = snapshot.data!.docs;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B9460),
            title: const Text(
              'Turmas',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              const CustomSwitcher(),
              IconButton(
                onPressed: () async {
                  await _firebaseAuth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: chatsCarregados.length,
                    itemBuilder: (context, index) {
                      final chat = chatsCarregados[index];
                      return ListTile(
                        leading: _buildIconForType(chat['tipo']),
                        contentPadding: const EdgeInsets.all(8),
                        title: Text(chatsCarregados[index].id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(chatId: chatsCarregados[index].id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF4B9460),
            foregroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Adicionar turmas'),
                    content: const Column(
                    mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: null,
                          decoration:  InputDecoration(labelText: 'Curso'),
                        ),
                        TextField(
                          controller: null,
                          decoration:  InputDecoration(labelText: 'Semestre'),
                        ),
                        TextField(
                          controller: null,
                          decoration:  InputDecoration(labelText: 'Código'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancelar',
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Adicionar',
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildIconForType(String tipo) {
    switch (tipo) {
      case 'math':
        return const Icon(Icons.calculate);
      case 'science':
        return const Icon(Icons.science);
      case 'history':
        return const Icon(Icons.history_edu);
      case 'language':
        return const Icon(Icons.language);
      case 'technology':
        return const Icon(Icons.computer);
      default:
        return const Icon(Icons.class_);
    }
  }
}

class CustomSwitcher extends StatelessWidget {
  const CustomSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppController.instance.changeTheme();
      },
      child: ValueListenableBuilder(
        valueListenable: AppController.instance,
        builder: (context, value, child) {
          return Icon(
            value ? Icons.wb_sunny : Icons.nightlight_round,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
