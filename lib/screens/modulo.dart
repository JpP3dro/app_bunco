import 'package:flutter/material.dart';

class TelaModulo extends StatefulWidget {
  const TelaModulo({super.key});


  @override
  State<TelaModulo> createState() => _TelaModuloState();
}

class _TelaModuloState extends State<TelaModulo> {
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