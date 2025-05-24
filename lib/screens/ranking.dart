import 'package:flutter/material.dart';

class TelaRanking extends StatefulWidget {
  const TelaRanking({super.key});


  @override
  State<TelaRanking> createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Ranking"),
      ),
      body: const Center(
        child: Text("Teste"),
      ),
    );
  }
}