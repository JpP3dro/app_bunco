import 'dart:convert';

import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../uteis/ip.dart';
import 'outroperfil.dart';

class TelaRanking extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const TelaRanking({
    super.key,
    required this.usuario
  });


  @override
  State<TelaRanking> createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking> {
  List<Map<String, dynamic>> primeiros = [];
  Map<String, dynamic>? voce;

  @override
  void initState() {
    super.initState();
    carregarRanking();
  }

  var response;

  Future<void> carregarRanking() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco_testes/api/ranking.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.usuario['username']
      }).timeout(const Duration(minutes: 1));
      response = jsonDecode(res.body);
      setState(() {
        primeiros = List<Map<String, dynamic>>.from(response['primeiros']);
        voce = Map<String, dynamic>.from(response['voce']);
      });
    }
    catch (e) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro ao atualizar o ranking",
          conteudo: "Algo deu errado ao atualizar o ranking! Tente de novo mais tarde!");
    }
  }

  Color? _medalColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // ouro
      case 1:
        return Colors.grey; // prata
      case 2:
        return Colors.brown; // bronze
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (voce == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Ranking",
            style: GoogleFonts.baloo2(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: primeiros.length + ((voce?['position'] ?? 0) > 15 ? 1 : 0),
        itemBuilder: (ctx, i) {
          // Se for depois do top15 e seu you.position >15, desenha seu card
          if (i == primeiros.length && voce!['position']! > 15) {
            return _buildTile(
              index: voce!['position']! - 1,
              username: voce!['username']!,
              xp: voce!['xp']!,
              isYou: true,
            );
          }
          // Senão, é um dos top
          final entry = primeiros[i];
          return _buildTile(
            index: i,
            username: entry['username'],
            xp: entry['xp'],
            isYou: (entry['username'] == widget.usuario['username']),
          );
        },
      ),
    );
  }

  Widget _buildTile({
    required int index,
    required String username,
    required int xp,
    bool isYou = false,
  }) {
    final medal = _medalColor(index);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OutroPerfil(usuario: username),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: isYou ? Colors.blueAccent : Colors.black87, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.topRight,
            children: [
              if (medal != null)
                Icon(FontAwesomeIcons.medal, color: medal, size: 30),
            ],
          ),
          title: Text(
            isYou ? '$username (você)' : username,
            style: TextStyle(
              fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Text('$xp XP'),
        ),
      ),
    );
  }
}
