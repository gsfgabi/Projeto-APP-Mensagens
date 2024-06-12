import 'package:flutter/material.dart';
import 'app_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          _buildNotificationTile(context),
          const Divider(),
          _buildThemeTile(context),
          const Divider(),
          _buildAboutTile(context),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Color(0xFF4B9460)),
      title: const Text('Notificações'),
      onTap: () {
        _showNotificationsModal(context);
      },
    );
  }

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
        // Lógica para a opção de Sobre
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    ThemeMode? selectedTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Selecionar Tema'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Claro'),
                    value: ThemeMode.light,
                    groupValue: selectedTheme,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        selectedTheme = value;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Escuro'),
                    value: ThemeMode.dark,
                    groupValue: selectedTheme,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        selectedTheme = value;
                      });
                    },
                  ),
                ],
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
                    if (selectedTheme != null) {
                      AppController.instance.setThemeMode(selectedTheme!);
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
      },
    );
  }

  void _showNotificationsModal(BuildContext context) {
    bool? _permitirNotificacoes = true; // Valor inicial para as notificações

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Notificações',
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SwitchListTile(
                title: const Text(
                  'Permitir Notificações',
                ),
                value: _permitirNotificacoes!,
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey,
                onChanged: (value) {
                  setState(() {
                    _permitirNotificacoes = value;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF4B9460))),
            ),
            TextButton(
              onPressed: () {
                // Faça algo com o valor de _permitirNotificacoes
                Navigator.of(context).pop();
              },
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF4B9460))),
            ),
          ],
        );
      },
    );
  }
}
