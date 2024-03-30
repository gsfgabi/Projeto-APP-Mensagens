import 'app_controller.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_student.dart';
import 'register_teacher.dart';
import 'chat_page.dart';

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
              '/': (context) => LoginPage(),
              '/chat': (context) => PaginaDeChats(),
              '/RegisterStudent': (context) => RegisterStudent(),
              '/RegisterTeacher': (context) => RegisterTeacher(),
            },
          );
        });
  }
}
