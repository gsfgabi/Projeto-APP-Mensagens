import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      return userData.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4B9460),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar dados'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Nenhum dado encontrado'),
            );
          }

          var userData = snapshot.data!;
          var nome = userData['usuario'] ?? 'Usuário';
          var email = userData['email'] ?? 'usuario@exemplo.com';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/usuario.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nome',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            nome,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'E-mail',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            email,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'Utils.dart';
// import 'resource/add_data.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   Uint8List? _image;

//   void selectImage() async {
//     Uint8List? img = await pickImage(ImageSource.gallery);
//     if (img != null) {
//       setState(() {
//         _image = img;
//       });
//     } else {
//       print("Nenhuma imagem selecionada");
//     }
//   }

//   void saveProfile() async {
//     await StoreData().saveData(file: _image!);
//   }

//   Future<Map<String, dynamic>?> _fetchUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
//           .instance
//           .collection('usuarios')
//           .doc(user.uid)
//           .get();

//       return userData.data();
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Perfil', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color(0xFF4B9460),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _fetchUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text('Erro ao carregar dados'),
//             );
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(
//               child: Text('Nenhum dado encontrado'),
//             );
//           }

//           var userData = snapshot.data!;
//           var nome = userData['usuario'] ?? 'Usuário';
//           var email = userData['email'] ?? 'usuario@exemplo.com';
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // const Center(
//                   //   child: CircleAvatar(
//                   //     radius: 50,
//                   //     backgroundImage: AssetImage('assets/images/usuario.jpg'),
//                   //   ),
//                   // ),
//                   Center(
//                     child: Stack(
//                       children: [
//                         _image != null
//                             ? CircleAvatar(
//                                 radius: 64,
//                                 backgroundImage: MemoryImage(_image!),
//                               )
//                             : const CircleAvatar(
//                                 radius: 64,
//                                 backgroundImage:
//                                     AssetImage('assets/images/usuario.jpg'),
//                               ),
//                         Positioned(
//                           bottom: -10,
//                           left: 80,
//                           child: IconButton(
//                             onPressed: selectImage,
//                             icon: const Icon(Icons.add_a_photo),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Nome',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             nome,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             'E-mail',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             email,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       saveProfile;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Perfil salvo com sucesso!'),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Salvar Perfil',
//                       style: TextStyle(color: Color(0xFF4B9460)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
