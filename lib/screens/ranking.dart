import 'dart:convert';
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../uteis/controle_login.dart';
import '../uteis/url.dart';
import 'outroperfil.dart';

class TelaRanking extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final bool modoEscuro;
  const TelaRanking(
      {super.key, required this.usuario, required this.modoEscuro});

  @override
  State<TelaRanking> createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> primeiros = [];
  Map<String, dynamic>? voce;

  @override
  bool get wantKeepAlive => true; // ← Isso preserva o estado

  @override
  void initState() {
    super.initState();
    carregarRanking();
  }

  Future<void> carregarRanking() async {
    if (!await verificarConexao()) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Sem conexão",
          conteudo:
              "Seu dispositivo está sem internet. Tente novamente quando tiver internet.");
      return;
    }
    try {
      String url = await obterUrl();
      String link = "$url/api/ranking.php";
      var res = await http.post(Uri.parse(link), body: {
        "username": widget.usuario['username']
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      setState(() {
        primeiros = List<Map<String, dynamic>>.from(response['primeiros']);
        voce = Map<String, dynamic>.from(response['voce']);
      });
    } catch (e) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro ao atualizar o ranking",
          conteudo:
              "Algo deu errado ao atualizar o ranking! Tente de novo mais tarde!");
    }
  }

  Color _corFundo(int index) {
    switch (index) {
      case 0:
        return Color(0xFFFDF0AB);
      case 1:
        return Color(0xFFE6E4E4);
      case 2:
        return Color(0xFFFFDBA8);
      default:
        return widget.modoEscuro ? Color(0xFF0D141F) : Colors.white;
    }
  }

  Color _corTexto(int index) {
    switch (index) {
      case 0:
        return Color(0xFFFFC800);
      case 1:
        return Color(0xFF9E9E9E);
      case 2:
        return Color(0xFFCD7F32);
      default:
        return Color(0xFF1CB0F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (voce == null) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: Color(0xFF1CB0F6),
        )),
      );
    }
    return Scaffold(
      backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ranking",
              style: GoogleFonts.baloo2(
                fontSize: 25,
                color:
                    widget.modoEscuro ? Color(0xFFB0C2DE) : Color(0xFF1CB0F6),
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Color(0xFF1CB0F6),
                size: 30,
              ),
              onPressed: () {
                carregarRanking();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/icone/trofeu.png', height: 180),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount:
                    primeiros.length + ((voce?['position'] ?? 0) > 15 ? 1 : 0),
                itemBuilder: (ctx, i) {
                  // Se for depois do top15 e seu you.position >15, desenha seu card
                  if (i == primeiros.length && voce!['position']! > 15) {
                    return _buildRanking(
                        index: voce!['position']! - 1,
                        nome: voce!['nome']!,
                        xp: voce!['xp']!,
                        isYou: true,
                        dados: voce);
                  }
                  // Senão, é um dos top
                  final entry = primeiros[i];
                  return _buildRanking(
                      index: i,
                      nome: entry['nome'],
                      xp: entry['xp'],
                      isYou: (entry['username'] == widget.usuario['username']),
                      dados: entry);
                },
              ),
            ),
          ],
        ),
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
    final corFundo = _corFundo(index);
    final corTexto = _corTexto(index);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TelaOutroPerfil(
                    usuario: dados,
                    modoEscuro: widget.modoEscuro,
                  )),
        );
      },
      child: Card(
        color: corFundo,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: index <= 2 ? Colors.transparent : Color(0xFF1CB0F6),
            width: index <= 2 ? 0 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: corFundo,
            boxShadow: index <= 2
                ? [
                    BoxShadow(
                      color: corTexto,
                      spreadRadius: 2, // quanto a sombra se espalha
                      blurRadius: 0,
                      offset: const Offset(3, 3),
                    ),
                  ]
                : null,
          ),
          height: 105,
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: ListTile(
            leading: Text(
              "${(index + 1).toString()}.",
              style: GoogleFonts.baloo2(
                  fontSize: 45, fontWeight: FontWeight.w700, color: corTexto),
            ),
            title: Text(
              isYou ? '$nome (você)' : nome,
              style: GoogleFonts.baloo2(
                  fontSize: 22, fontWeight: FontWeight.w700, color: corTexto),
            ),
            trailing: Text(
              '$xp XP',
              style: GoogleFonts.baloo2(
                  fontSize: 16, fontWeight: FontWeight.w700, color: corTexto),
            ),
          ),
        ),
      ),
    );
  }
}
