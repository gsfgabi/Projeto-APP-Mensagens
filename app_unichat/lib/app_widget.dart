import 'app_controller.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_student.dart';
import 'register_teacher.dart';
import 'class_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.amber,
            brightness: AppController.instance.darkTheme
                ? Brightness.dark
                : Brightness.light),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/turma': (context) => const PaginaDeTurmas(),
          '/RegisterStudent': (context) => const RegisterStudent(),
          '/RegisterTeacher': (context) => const RegisterTeacher(),
          // '/chat': (context) => const RegisterTeacher(),
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
            return const PaginaDeTurmas();
          }
          return const LoginPage();
        },
      ),
      );
    });
  }
}
