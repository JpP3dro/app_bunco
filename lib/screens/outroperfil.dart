import 'package:flutter/material.dart';

class OutroPerfil extends StatefulWidget {
  final String usuario;
  const OutroPerfil({
    super.key,
    required this.usuario
  });


  @override
  State<OutroPerfil> createState() => _OutroPerfilState();
}

class _OutroPerfilState extends State<OutroPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terminal"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}