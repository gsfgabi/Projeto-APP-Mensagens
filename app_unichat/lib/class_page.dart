import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curso_flutter_flutterando/chat_page.dart';
import 'package:curso_flutter_flutterando/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController nomeController = TextEditingController();
  int? _selectedSemester;
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
      builder: (context, salasSnapshot) {
        if (salasSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (salasSnapshot.hasError) {
          return const Center(
            child: Text('Algum erro desconhecido ocorreu'),
          );
        }

        final salasCarregadas = salasSnapshot.data!.docs;

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
                  //child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSectionHeader('Salas Participantes'),
                      ...salasCarregadas.map((sala) {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('salas-participantes')
                              .doc(sala.id) // Utilizamos o ID da sala para recuperar os dados do curso
                              .get(),
                          builder: (context, cursoSnapshot) {
                            if (cursoSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (cursoSnapshot.hasError) {
                              return Text('Erro ao carregar curso: ${cursoSnapshot.error}');
                            }
                            final cursoData = cursoSnapshot.data!.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: _buildIconForType(cursoData['area']),
                              contentPadding: const EdgeInsets.all(8),
                              title: Text(cursoData['nome']),
                              subtitle: Text(
                                  'Semestre: ${cursoData['semestre']} - Código: ${cursoData['codigo']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(chatId: sala.id),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ],
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
                                      const InputDecoration(labelText: 'Nome do curso'),
                                ),
                                DropdownButtonFormField<int>(
                                  value: _selectedSemester,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSemester = value;
                                    });
                                  },
                                  items: List.generate(12, (index) => index + 1)
                                      .map((semester) => DropdownMenuItem<int>(
                                            value: semester,
                                            child: Text('$semester°'),
                                          ))
                                      .toList(),
                                  decoration: const InputDecoration(labelText: 'Semestre'),
                                ),
                                TextField(
                                  controller: codigoController,
                                  decoration:
                                      const InputDecoration(labelText: 'Código da turma'),
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedArea,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedArea = value;
                                    });
                                  },
                                  items: const [
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
                                  decoration: const InputDecoration(
                                      labelText: 'Área de Conhecimento'),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIconForType(String area) {
    switch (area) {
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
        _selectedSemester == null ||
        codigoController.text.trim().isEmpty ||
        _selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        .collection('salas-participantes')
        .where('codigo', isEqualTo: codigo)
        .get();

    if (cursosSnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Já existe um curso com o código informado'),
        ),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final email = [user.email];

      await FirebaseFirestore.instance.collection('salas-participantes').add({
        'nome': nome,
        'semestre': _selectedSemester,
        'codigo': codigo,
        'area': _selectedArea,
        'email': email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Curso cadastrado com sucesso!'),
        ),
      );
      // Limpar os controladores após o cadastro
      nomeController.clear();
      setState(() {
        _selectedSemester = null;
        _selectedArea = null;
      });
      codigoController.clear();
      Navigator.of(context).pop(); // Fechar o modal após o cadastro
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar o curso. Tente novamente.'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ClassPage(),
  ));
}
