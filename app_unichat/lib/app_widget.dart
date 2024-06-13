import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/app_controller.dart';
import 'pages/class_page.dart';
import 'pages/login_page.dart';
import 'register/register_student.dart';
import 'register/register_teacher.dart';
import 'register/register_coordinator.dart';
import 'pages/password/forgot_password_page.dart';
import 'pages/chat_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppController.instance,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF4B9460),
            primarySwatch: Colors.green, 
            brightness: value ? Brightness.dark : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/login': (context) => const LoginPage(),
            '/turma': (context) => const ClassPage(),
            '/RegisterStudent': (context) => const RegisterStudent(),
            '/RegisterTeacher': (context) => const RegisterTeacher(),
            '/RegisterCoordinator': (context) => const RegisterCoordinator(),
            '/esqueciSenha': (context) => const ForgotPasswordPage(),
            '/conversa': (context) => const ChatPage(chatId: "", curso: ""),
          },
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return const ClassPage();
              }
              return const LoginPage();
            },
          ),
        );
      },
    );
  }
}
