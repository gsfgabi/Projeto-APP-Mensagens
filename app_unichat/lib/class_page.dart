import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curso_flutter_flutterando/chat_page.dart';
import 'package:curso_flutter_flutterando/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController nomeController = TextEditingController();
  int? _selectedSemester;
  final TextEditingController codigoController = TextEditingController();
  String? _selectedArea;
  bool isAdmin = false;
  bool isProfessor = false;
  bool isCoordenador = false;

  List<String> cursos = [];
  String? _selectedCurso;
  bool isAddingNewCourse = false;

  @override
  void initState() {
    super.initState();
    _verificarPermissoes();
    _carregarCursos();
  }

  Future<void> _verificarPermissoes() async {
    final usuario = _firebaseAuth.currentUser;
    if (usuario != null) {
      final usuarioDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: usuario.email)
          .get();

      if (usuarioDoc.docs.isNotEmpty) {
        final dadosUsuario = usuarioDoc.docs.first.data();
        setState(() {
          isAdmin = dadosUsuario['isAdmin'] ?? false;
          isProfessor = dadosUsuario['isProfessor'] ?? false;
          isCoordenador = dadosUsuario['isCoordenador'] ?? false;
        });
      }
    }
  }

Future<void> _carregarCursos() async {
  final cursosSnapshot =
      await FirebaseFirestore.instance.collection('salas-participantes').get();
  setState(() {
    cursos = cursosSnapshot.docs.map((doc) => doc['nome'] as String).toList();
    cursos.sort(); // Ordenar os cursos em ordem alfabética
    cursos.insert(0, "Adicionar novo curso"); // Adicionar a opção "Adicionar novo curso" no início da lista
  });
}



  void configuraNotificacoes(chatsCarregados, usuarioAutenticado) async {
    final firebaseMessageria = FirebaseMessaging.instance;
    await firebaseMessageria.requestPermission();

    for (var documento in chatsCarregados) {
      for (var email in documento['email']) {
        if (email == usuarioAutenticado.email) {
          firebaseMessageria.subscribeToTopic(documento.id);
        }
      }
    }
  }

  void _adicionarChat() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Chat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCurso,
                  onChanged: (value) {
                    setState(() {
                      _selectedCurso = value;
                    });
                  },
                  items: cursos.map((curso) {
                    return DropdownMenuItem(
                      value: curso,
                      child: Text(curso),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Selecione o Curso'),
                ),
                TextField(
                  controller: codigoController,
                  decoration: const InputDecoration(labelText: 'Código da Turma'),
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
                _salvarChat(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _salvarChat(BuildContext context) async {
    final curso = _selectedCurso?.trim().toUpperCase();
    final codigo = codigoController.text.trim().toUpperCase();

    final cursoSnapshot = await FirebaseFirestore.instance
        .collection('salas-participantes')
        .where('nome', isEqualTo: curso)
        .where('codigo', isEqualTo: codigo)
        .get();

    if (cursoSnapshot.docs.isNotEmpty) {
      final chatId = cursoSnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('salas-participantes')
          .doc(chatId)
          .update({
        'email': FieldValue.arrayUnion([_firebaseAuth.currentUser!.email])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat adicionado com sucesso!'),
        ),
      );

      nomeController.clear();
      codigoController.clear();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Curso e/ou código da turma incorretos.'),
        ),
      );
    }
  }

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
        configuraNotificacoes(salasCarregadas, usuarioAutenticado);

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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
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
                              return const CircularProgressIndicator();
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
                                        ChatPage(chatId: sala.id, curso: cursoData['nome']),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: isCoordenador
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFF4B9460),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Cadastrar Curso'),
                          content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: _selectedCurso,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCurso = value;
                                          isAddingNewCourse = value == "Adicionar novo curso";
                                        });
                                      },
                                      items: cursos.map((curso) {
                                        return DropdownMenuItem(
                                          value: curso,
                                          child: Text(curso),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                          labelText: 'Selecione ou adicione um curso'),
                                    ),
                                    if (isAddingNewCourse)
                                      TextField(
                                        controller: nomeController,
                                        decoration: const InputDecoration(
                                            labelText: 'Nome do Curso'),
                                      ),
                                  DropdownButtonFormField<int>(
                                  value: _selectedSemester,
                                  onChanged: (value) {
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
                                      decoration: const InputDecoration(
                                          labelText: 'Código do Curso'),
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
                              );
                            },
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
              : FloatingActionButton(
                  backgroundColor: const Color(0xFF4B9460),
                  foregroundColor: Colors.white,
                  onPressed: _adicionarChat,
                  child: const Icon(Icons.chat),
                ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIconForType(String area) {
    switch (area) {
      case 'MATEMÁTICA':
        return const Icon(Icons.calculate);
      case 'CIÊNCIA':
        return const Icon(Icons.science);
      case 'HISTÓRIA':
        return const Icon(Icons.history_edu);
      case 'LINGUAGENS':
        return const Icon(Icons.language);
      case 'TECNOLOGIA':
        return const Icon(Icons.computer);
      default:
        return const Icon(Icons.class_);
    }
  }

  void _salvarCurso(BuildContext context) async {
    if ((isAddingNewCourse && nomeController.text.trim().isEmpty) ||
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

    final nome = isAddingNewCourse
        ? nomeController.text.trim().toUpperCase()
        : _selectedCurso!.toUpperCase();
    final codigo = codigoController.text.trim().toUpperCase();

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

      nomeController.clear();
      setState(() {
        _selectedSemester = null;
        _selectedArea = null;
        isAddingNewCourse = false;
        _selectedCurso = null;
      });
      codigoController.clear();
      Navigator.of(context).pop();
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
  runApp(const MaterialApp(
    home: ClassPage(),
  ));
}
