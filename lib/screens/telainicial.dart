import 'package:flutter/material.dart';


class TelaInicial extends StatefulWidget {
  final Map<String, dynamic> usuario;
   const TelaInicial({
    super.key,
    required this.usuario
  });

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Inicial"),
        automaticallyImplyLeading: false, // Remove botão de voltar
      ),
      body: const Center(
        child: Text(
          "Bem-vindo à Tela Inicial!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}