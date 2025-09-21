import 'package:app_bunco/screens/configuracoes.dart';
import 'package:app_bunco/screens/curso.dart';
import 'package:app_bunco/screens/meuperfil.dart';
import 'package:app_bunco/screens/ranking.dart';
import 'package:app_bunco/screens/terminal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaInicial extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  final bool parametroModoEscuro;
   const TelaInicial({
    super.key,
    required this.usuario,
     required this.parametroModoEscuro,
  });

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late bool modoEscuro;
  int myIndex = 0;

  @override
  void initState() {
    super.initState();
    modoEscuro = widget.parametroModoEscuro;
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      TelaCurso(usuario: widget.usuario!, modoEscuro: modoEscuro,),
      TelaRanking(usuario: widget.usuario!, modoEscuro: modoEscuro,),
      TelaTerminal(modoEscuro: modoEscuro),
      TelaPerfil(usuario: widget.usuario!, modoEscuro: modoEscuro),
      TelaConfiguracoes(usuario: widget.usuario!,
        parametroModoEscuro: modoEscuro,
        onModoEscuroChanged: (novoValor) {
          setState(() {
            modoEscuro = novoValor;
          });
        },),
    ];
    return PopScope(
      canPop: myIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && myIndex != 0) {
          setState(() {
            myIndex = 0; // volta para a primeira aba
          });
        }
      },
        child: Scaffold(
          body: Center(
            child: telas[myIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: (index){
              setState(() {
                myIndex = index;
              });
            },
            currentIndex: myIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home, size: 30,), label: "Home", backgroundColor: Color(0xFF1CB0F6)),
              BottomNavigationBarItem(icon: Icon(Icons.emoji_events, size: 30,), label: "Ranking", backgroundColor: Color(0xFF1CB0F6)),
              BottomNavigationBarItem(icon: Icon(Icons.terminal, size: 30,), label: "Terminal", backgroundColor: Color(0xFF1CB0F6)),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30,), label: "Perfil", backgroundColor: Color(0xFF1CB0F6)),
              BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30,), label: "Configurações", backgroundColor: Color(0xFF1CB0F6)),
            ],
            unselectedItemColor: Color(0xFF0D141F),
            selectedLabelStyle: GoogleFonts.baloo2(
                fontWeight: FontWeight.w700
            ),
          ),
        ),
    );
  }
}