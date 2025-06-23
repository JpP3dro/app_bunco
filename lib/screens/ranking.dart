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
      String url = "http://$ip/bunco/api/ranking.php";
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

  Color? _corMedalha(int index) {
    switch (index) {
      case 0:
        return Colors.amberAccent; // ouro
      case 1:
        return Color(0xFF686868); // prata
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ranking",
                style: GoogleFonts.baloo2(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  carregarRanking();
                },
              ),
            ],
          ),
          ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: primeiros.length + ((voce?['position'] ?? 0) > 15 ? 1 : 0),
          itemBuilder: (ctx, i) {
            // Se for depois do top15 e seu you.position >15, desenha seu card
            if (i == primeiros.length && voce!['position']! > 15) {
              return _buildRanking(
                  index: voce!['position']! - 1,
                  nome: voce!['nome']!,
                  xp: voce!['xp']!,
                  isYou: true,
                  dados: voce
              );
            }
            // Senão, é um dos top
            final entry = primeiros[i];
            return _buildRanking(
                index: i,
                nome: entry['nome'],
                xp: entry['xp'],
                isYou: (entry['username'] == widget.usuario['username']),
                dados: entry
            );
          },
        ),
    );
  }

  Widget _buildRanking({
    required int index,
    required String nome,
    required int xp,
    bool isYou = false,
    required Map<String, dynamic>? dados,
  }) {
    final medalha = _corMedalha(index);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TelaOutroPerfil(usuario: dados)
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isYou ? Colors.blueAccent : Colors.black87,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: ListTile(
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: isYou
                        ? AssetImage('assets/images/perfil/${widget.usuario['foto']}')
                        : AssetImage('assets/images/perfil/${dados!['foto']}'),
                    backgroundColor: isYou
                        ? Color(int.parse("0xFF${widget.usuario['cor']}"))
                        : Color(int.parse("0xFF${dados!['cor']}")),
                  ),
                  if (medalha != null)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        FontAwesomeIcons.medal,
                        color: medalha,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
            title: Text(
              isYou ? '$nome (você)' : nome,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Text(
                '$xp XP',
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
      ),
    );
  }
}
