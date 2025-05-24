import 'package:flutter/material.dart';

class TelaTerminal extends StatefulWidget {
  const TelaTerminal({super.key});


  @override
  State<TelaTerminal> createState() => _TelaTerminalState();
}

class _TelaTerminalState extends State<TelaTerminal> {
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