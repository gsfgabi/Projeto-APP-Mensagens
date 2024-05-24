import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_controller.dart';
import 'class_page.dart';
import 'login_page.dart';
import 'register_student.dart';
import 'register_teacher.dart';
import 'register_coordinator.dart';
import 'forgot_password_page.dart';
import 'chat_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppController.instance,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: value ? Brightness.dark : Brightness.light,
            ),
            initialRoute: '/',
            routes: {
              '/login': (context) => const LoginPage(),
              '/turma': (context) => const ClassPage(),
              '/RegisterStudent': (context) => const RegisterStudent(),
              '/RegisterTeacher': (context) => const RegisterTeacher(),
              '/RegisterCoodinator': (context) => const RegisterCoodinator(),
              '/esqueciSenha': (context) => ForgotPasswordPage(),
              '/conversa': (context) => const ChatPage(chatId: "",),
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
        });
  }
}
