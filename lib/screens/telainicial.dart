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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Inicial"),
        automaticallyImplyLeading: false, // Remove botão de voltar
      ),
      body: const Center(
        child: Text(
          "Bem-vindo à Tela Inicial!",
          style: TextStyle(fontSize: 20),
        ),
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