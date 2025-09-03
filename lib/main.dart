import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/telainicial.dart';
import 'uteis/controle_login.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // só retrato normal
    DeviceOrientation.portraitDown, // permite de cabeça pra baixo também
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return FutureBuilder<bool>(
            future: verificarLogin(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!) {
                return TelaInicial(
                  usuario: usuario,
                  parametroModoEscuro:
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark,
                );
              } else {
                return const TelaLogin();
              }
            },
          );
        },
      ),
    );
  }
}
