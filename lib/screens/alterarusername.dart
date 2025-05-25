import 'package:flutter/material.dart';

class TelaAlterarUsername extends StatefulWidget {
  const TelaAlterarUsername({super.key});


  @override
  State<TelaAlterarUsername> createState() => _TelaAlterarUsernameState();
}

class _TelaAlterarUsernameState extends State<TelaAlterarUsername> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar username"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}