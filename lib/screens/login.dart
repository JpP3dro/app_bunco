// second_screen.dart
import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Você está na Segunda Tela!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}