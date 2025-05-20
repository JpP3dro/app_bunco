import 'dart:convert';
import 'package:flutter/material.dart';
import '../ip.dart';
import 'package:http/http.dart' as http;


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