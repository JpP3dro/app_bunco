import 'package:flutter/material.dart';


class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

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