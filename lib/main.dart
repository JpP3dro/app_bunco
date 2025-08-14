import 'package:app_bunco/screens/telainicial.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'uteis/controle_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: verificarLogin(context),
        builder: (context, snapshot) {
          dispositivoModoEscuro(context);
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!) {
            return TelaInicial(
              usuario: usuario,
              parametroModoEscuro: parametroModoEscuro,
            );
          } else {
            return const TelaLogin();
          }
        },
      ),
    );
  }

}