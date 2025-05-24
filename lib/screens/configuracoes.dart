import 'package:flutter/material.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});


  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
  }
  
  class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Configurações"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
  }