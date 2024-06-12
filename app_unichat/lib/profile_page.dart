import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF4B9460),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/profile_picture.png'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nome',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Usuário',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'usuario@exemplo.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navegar para a página de edição de perfil
                },
                child: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B9460), // Cor do botão
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para sair do perfil
                },
                child: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor do botão
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
