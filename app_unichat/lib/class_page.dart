import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_controller.dart';
import 'chat_page.dart';
import 'login_page.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController semestreController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  String? _selectedArea;

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
          floatingActionButton: usuarioAutenticado.email == 'admin@unicv.edu.br'
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFF4B9460),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Cadastrar Curso'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nomeController,
                                  decoration:
                                      InputDecoration(labelText: 'Nome do curso'),
                                ),
                                TextField(
                                  controller: semestreController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(labelText: 'Semestre'),
                                ),
                                TextField(
                                  controller: codigoController,
                                  decoration:
                                      InputDecoration(labelText: 'Código da turma'),
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedArea,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedArea = value;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: 'MATEMÁTICA',
                                      child: Row(
                                        children: [
                                          Icon(Icons.calculate),
                                          SizedBox(width: 10),
                                          Text('MATEMÁTICA'),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'CIÊNCIA',
                                      child: Row(
                                        children: [
                                          Icon(Icons.science),
                                          SizedBox(width: 10),
                                          Text('CIÊNCIA'),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'HISTÓRIA',
                                      child: Row(
                                        children: [
                                          Icon(Icons.history_edu),
                                          SizedBox(width: 10),
                                          Text('HISTÓRIA'),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'LINGUAGENS',
                                      child: Row(
                                        children: [
                                          Icon(Icons.language),
                                          SizedBox(width: 10),
                                          Text('LINGUAGENS'),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'TECNOLOGIA',
                                      child: Row(
                                        children: [
                                          Icon(Icons.computer),
                                          SizedBox(width: 10),
                                          Text('TECNOLOGIA'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  decoration: InputDecoration(labelText: 'Área de Conhecimento'),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _salvarCurso(context);
                              },
                              child: const Text('Adicionar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
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

void _salvarCurso(BuildContext context) async {
  if (nomeController.text.trim().isEmpty ||
      semestreController.text.trim().isEmpty ||
      codigoController.text.trim().isEmpty ||
      _selectedArea == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preencha todos os campos antes de salvar'),
      ),
    );
    return;
  }

  // Normalizar os campos para maiúsculas
  final nome = nomeController.text.trim().toUpperCase();
  final codigo = codigoController.text.trim().toUpperCase();

  // Verificar se o código do curso já existe
  final cursosSnapshot = await FirebaseFirestore.instance
      .collection('cursos')
      .where('codigo', isEqualTo: codigo)
      .get();

  if (cursosSnapshot.docs.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Já existe um curso com o código informado'),
      ),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('cursos').add({
      'nome': nome,
      'semestre': semestreController.text,
      'codigo': codigo,
      'area': _selectedArea,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Curso cadastrado com sucesso!'),
      ),
    );
    // Limpar os controladores após o cadastro
    nomeController.clear();
    semestreController.clear();
    codigoController.clear();
    setState(() {
      _selectedArea = null;
    });
    Navigator.of(context).pop(); // Fechar o modal após o cadastro
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao cadastrar o curso. Tente novamente.'),
        ),
      );
    }
  }
}

class CustomSwitcher extends StatelessWidget {
  const CustomSwitcher({Key? key}) : super(key: key);

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
