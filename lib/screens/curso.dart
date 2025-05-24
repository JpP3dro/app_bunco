import 'package:flutter/material.dart';

class TelaCurso extends StatefulWidget {
  const TelaCurso({super.key});


  @override
  State<TelaCurso> createState() => _TelaCursoState();
}

class _TelaCursoState extends State<TelaCurso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Curso"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}