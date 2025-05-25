import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});


  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Perfil",
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}