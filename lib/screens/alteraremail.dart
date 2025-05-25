import 'package:flutter/material.dart';

class TelaAlterarEmail extends StatefulWidget {
  const TelaAlterarEmail({super.key});


  @override
  State<TelaAlterarEmail> createState() => _TelaAlterarEmailState();
}

class _TelaAlterarEmailState extends State<TelaAlterarEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar email"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}