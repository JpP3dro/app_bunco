import 'package:flutter/material.dart';

class TelaAlterarSenha extends StatefulWidget {
  const TelaAlterarSenha({super.key});


  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar senha"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}