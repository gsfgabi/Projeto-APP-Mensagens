import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_controller.dart';
import 'about_page.dart';
// import 'login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme =
        AppController.instance.darkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B9460),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // _buildNotificationTile(context),
          // const Divider(),
          _buildThemeTile(context),
          const Divider(),
          _buildAboutTile(context),
          // const Divider(),
          // _buildExitTile(context),
        ],
      ),
    );
  }

  // Widget _buildNotificationTile(BuildContext context) {
  //   return ListTile(
  //     leading: const Icon(Icons.notifications, color: Color(0xFF4B9460)),
  //     title: const Text('Notificações'),
  //     onTap: () {
  //       _showNotificationsModal(context);
  //     },
  //   );
  // }

  Widget _buildThemeTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_6, color: Color(0xFF4B9460)),
      title: const Text('Tema'),
      onTap: () {
        _showThemeSelectionDialog(context);
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info, color: Color(0xFF4B9460)),
      title: const Text('Sobre'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    ThemeMode? _tempSelectedTheme = _selectedTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar Tema'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Claro'),
                    value: ThemeMode.light,
                    groupValue: _tempSelectedTheme,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _tempSelectedTheme = value;
                      });
                    },
                    activeColor: const Color(0xFF4B9460),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Escuro'),
                    value: ThemeMode.dark,
                    groupValue: _tempSelectedTheme,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _tempSelectedTheme = value;
                      });
                    },
                    activeColor: const Color(0xFF4B9460),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
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
                if (_tempSelectedTheme != null) {
                  setState(() {
                    _selectedTheme = _tempSelectedTheme!;
                  });
                  AppController.instance
                      .setThemeMode(_tempSelectedTheme == ThemeMode.dark);
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF4B9460)),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _showNotificationsModal(BuildContext context) {
  //   bool? permitirNotificacoes = true;

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Notificações',
  //         ),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return SwitchListTile(
  //               title: const Text(
  //                 'Permitir Notificações',
  //               ),
  //               value: permitirNotificacoes!,
  //               activeColor: Colors.green,
  //               inactiveTrackColor: Colors.grey,
  //               onChanged: (value) {
  //                 setState(() {
  //                   permitirNotificacoes = value;
  //                 });
  //               },
  //             );
  //           },
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancelar',
  //                 style: TextStyle(color: Color(0xFF4B9460))),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child:
  //                 const Text('OK', style: TextStyle(color: Color(0xFF4B9460))),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
