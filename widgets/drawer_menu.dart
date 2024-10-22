import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            title: Text('Homepage da Empresa'),
            onTap: () {
              // Encaminhar p/ página da empresa
            },
          ),
          ListTile(
            title: Text('Contato'),
            onTap: () {
              // Adicionar lógica para mostrar o contato da empresa qd clica
            },
          ),
          ListTile(
            title: Text('Endereço da Empresa'),
            onTap: () {
              // Adicionar endereço da empresa
            },
          ),
          ListTile(
            title: Text('Sair'),
            onTap: () {
              // Retorna ao login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
