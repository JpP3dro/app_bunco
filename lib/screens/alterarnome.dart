import 'package:flutter/material.dart';

class TelaAlterarNome extends StatefulWidget {
  const TelaAlterarNome({super.key});


  @override
  State<TelaAlterarNome> createState() => _TelaAlterarNomeState();
}

class _TelaAlterarNomeState extends State<TelaAlterarNome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar nome"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}