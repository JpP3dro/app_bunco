import 'package:flutter/material.dart';

class TelaAlterarLinks extends StatefulWidget {
  const TelaAlterarLinks({super.key});


  @override
  State<TelaAlterarLinks> createState() => _TelaAlterarLinksState();
}

class _TelaAlterarLinksState extends State<TelaAlterarLinks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar links de redes sociais"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}