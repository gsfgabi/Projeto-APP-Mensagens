import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curso_flutter_flutterando/pages/chat_page.dart';
import 'package:curso_flutter_flutterando/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'profile_page.dart';
import 'settings_page.dart';

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
  String? _selectedTipoCurso;
  String? _selectedModalidade;
  bool isProfessor = false;
  bool isCoordenador = false;

  List<String> cursos = [];
  String? _selectedCurso;
  bool isAddingNewCourse = false;

  void _logout() async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

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
          isProfessor = dadosUsuario['isProfessor'] ?? false;
          isCoordenador = dadosUsuario['isCoordenador'] ?? false;
        });
      }
    }
  }

  Future<void> _carregarCursos() async {
    final cursosSnapshot = await FirebaseFirestore.instance
        .collection('salas-participantes')
        .get();
    final List<String> cursosExistentes = [];
    final Set<String> nomesCursos =
        {}; // Conjunto para garantir nomes de cursos únicos

    cursosSnapshot.docs.forEach((doc) {
      final nomeCurso = doc['nome'] as String;
      if (!nomesCursos.contains(nomeCurso)) {
        cursosExistentes.add(nomeCurso);
        nomesCursos.add(nomeCurso);
      }
    });

    setState(() {
      cursos = cursosExistentes;
      cursos.sort(); // Ordenar os cursos em ordem alfabética
      cursos.insert(0,
          "Adicionar nova turma"); // Adicionar a opção "Adicionar nova turma" no início da lista
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
                  decoration:
                      const InputDecoration(labelText: 'Selecione a Turma'),
                ),
                TextField(
                  controller: codigoController,
                  decoration:
                      const InputDecoration(labelText: 'Código da Turma'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF4B9460)),
              ),
            ),
            TextButton(
              onPressed: () {
                _salvarChat(context);
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(color: Color(0xFF4B9460)),
              ),
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
          content: Text('Turma e/ou código da turma incorretos.'),
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
          // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B9460),
            title: SizedBox(
              width: 100,
              height: 50,
              child: Image.asset('assets/images/logounicvbranco.png'),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              // IconButton(
              //   onPressed: () async {
              //     await _firebaseAuth.signOut();
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => const LoginPage()),
              //     );
              //   },
              //   icon: const Icon(Icons.exit_to_app),
              // ),
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'profile') {
                    // Navegue para a página de perfil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  } else if (value == 'settings') {
                    // Navegue para a página de configurações
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  } else if (value == 'logout') {
                    _logout();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Perfil'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configuração'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Sair'),
                      ),
                    ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
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
                      _buildSectionHeader('Chats'),
                      ...salasCarregadas.map((sala) {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('salas-participantes')
                              .doc(sala
                                  .id) // Utilizamos o ID da sala para recuperar os dados do curso
                              .get(),
                          builder: (context, cursoSnapshot) {
                            if (cursoSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (cursoSnapshot.hasError) {
                              return Text(
                                  'Erro ao carregar turma: ${cursoSnapshot.error}');
                            }
                            final cursoData = cursoSnapshot.data!.data()
                                as Map<String, dynamic>;
                            return ListTile(
                              leading:
                                  _buildIconForType(cursoData['tipoCurso']),
                              contentPadding: const EdgeInsets.all(8),
                              title: Text(cursoData['nome']),
                              subtitle: Text(
                                  'Semestre: ${cursoData['semestre']} - Código: ${cursoData['codigo']} - Modalidade: ${cursoData['modalidade']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        chatId: sala.id,
                                        curso: cursoData['nome']),
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
                          title: const Text('Cadastrar Turma'),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: _selectedCurso,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCurso = value;
                                          isAddingNewCourse =
                                              value == "Adicionar nova turma";
                                        });
                                      },
                                      items: cursos.map((curso) {
                                        return DropdownMenuItem(
                                          value: curso,
                                          child: Text(curso),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                          labelText:
                                              'Selecione ou adicione uma turma'),
                                    ),
                                    if (isAddingNewCourse)
                                      TextField(
                                        controller: nomeController,
                                        decoration: const InputDecoration(
                                            labelText: 'Nome da Turma'),
                                      ),
                                    DropdownButtonFormField<int>(
                                      value: _selectedSemester,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSemester = value;
                                        });
                                      },
                                      items: List.generate(
                                              12, (index) => index + 1)
                                          .map((semester) =>
                                              DropdownMenuItem<int>(
                                                value: semester,
                                                child: Text('$semester°'),
                                              ))
                                          .toList(),
                                      decoration: const InputDecoration(
                                          labelText: 'Semestre'),
                                    ),
                                    TextField(
                                      controller: codigoController,
                                      decoration: const InputDecoration(
                                          labelText: 'Código da Turma'),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _selectedTipoCurso,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTipoCurso = value;
                                        });
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'BACHARELADO',
                                          child: Row(
                                            children: [
                                              Icon(Icons.school),
                                              SizedBox(width: 10),
                                              Text('BACHARELADO'),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'LICENCIATURA',
                                          child: Row(
                                            children: [
                                              Icon(Icons.menu_book),
                                              SizedBox(width: 10),
                                              Text('LICENCIATURA'),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'TECNÓLOGO',
                                          child: Row(
                                            children: [
                                              Icon(Icons.computer),
                                              SizedBox(width: 10),
                                              Text('TECNÓLOGO'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'Tipo de Curso'),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _selectedModalidade,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedModalidade = value;
                                        });
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'PRESENCIAL',
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on),
                                              SizedBox(width: 10),
                                              Text('PRESENCIAL'),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'EAD',
                                          child: Row(
                                            children: [
                                              Icon(Icons.computer),
                                              SizedBox(width: 10),
                                              Text('EAD'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'Modalidade'),
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
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Color(0xFF4B9460)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _salvarCurso(context);
                              },
                              child: const Text(
                                'Adicionar',
                                style: TextStyle(color: Color(0xFF4B9460)),
                              ),
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

  Widget _buildIconForType(String tipoCurso) {
    switch (tipoCurso) {
      case 'BACHARELADO':
        return const Icon(Icons.school);
      case 'LICENCIATURA':
        return const Icon(Icons.menu_book);
      case 'TECNÓLOGO':
        return const Icon(Icons.computer);
      default:
        return const Icon(Icons.class_);
    }
  }

  void _salvarCurso(BuildContext context) async {
    if ((_selectedCurso == "Adicionar nova turma" &&
            nomeController.text.trim().isEmpty) ||
        _selectedSemester == null ||
        codigoController.text.trim().isEmpty ||
        _selectedTipoCurso == null ||
        _selectedModalidade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos antes de salvar'),
        ),
      );
      return;
    }

    final nome = _selectedCurso == "Adicionar nova turma"
        ? nomeController.text.trim().toUpperCase()
        : _selectedCurso!.toUpperCase();
    final codigo = codigoController.text.trim().toUpperCase();

    // Verifica se o curso selecionado já existe na lista de cursos
    if (_selectedCurso != "Adicionar nova turma" && !cursos.contains(nome)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O curso selecionado não existe'),
        ),
      );
      return;
    }

    // Verifica se já existe uma turma com o mesmo código
    final cursosSnapshot = await FirebaseFirestore.instance
        .collection('salas-participantes')
        .where('codigo', isEqualTo: codigo)
        .get();

    if (cursosSnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Já existe uma turma com o código informado'),
        ),
      );
      return;
    }

    // Verifica se já existe uma turma com o mesmo nome, apenas se o curso selecionado for "Adicionar nova turma"
    if (_selectedCurso == "Adicionar nova turma") {
      final nomeCursoSnapshot = await FirebaseFirestore.instance
          .collection('salas-participantes')
          .where('nome', isEqualTo: nome)
          .get();

      if (nomeCursoSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Já existe uma turma com o nome informado'),
          ),
        );
        return;
      }
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final email = [user.email];

      await FirebaseFirestore.instance.collection('salas-participantes').add({
        'nome': nome,
        'semestre': _selectedSemester,
        'codigo': codigo,
        'tipoCurso': _selectedTipoCurso,
        'modalidade': _selectedModalidade,
        'email': email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Turma cadastrada com sucesso!'),
        ),
      );

      nomeController.clear();
      setState(() {
        _selectedSemester = null;
        _selectedTipoCurso = null;
        _selectedModalidade = null;
        isAddingNewCourse = false;
        _selectedCurso = null;
      });
      codigoController.clear();
      Navigator.of(context).pop();
      _carregarCursos(); // Recarregar a lista de cursos
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar a turma. Tente novamente.'),
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
