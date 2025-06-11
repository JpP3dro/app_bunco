import 'package:app_bunco/screens/configuracoes.dart';
import 'package:app_bunco/screens/curso.dart';
import 'package:app_bunco/screens/meuperfil.dart';
import 'package:app_bunco/screens/ranking.dart';
import 'package:app_bunco/screens/terminal.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  final Map<String, dynamic> usuario;
   const TelaInicial({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int myIndex = 0;
  late List<Widget> telas;

  @override
  void initState() {
    super.initState();
    telas = [
      const TelaCurso(),
      TelaRanking(usuario: widget.usuario,),
      const TelaTerminal(),
      TelaPerfil(usuario: widget.usuario),
      TelaConfiguracoes(usuario: widget.usuario),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.lightBlueAccent),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Ranking", backgroundColor: Colors.orange),
        BottomNavigationBarItem(icon: Icon(Icons.terminal), label: "Terminal", backgroundColor: Colors.black),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Perfil", backgroundColor: Colors.blueAccent),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configurações", backgroundColor: Colors.green),
          ],
      ),
    );
  }
}