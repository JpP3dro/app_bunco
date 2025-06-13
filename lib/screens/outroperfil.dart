import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../uteis/tipo_dialogo.dart';
import '../uteis/dialogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TelaOutroPerfil extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  const TelaOutroPerfil({
    super.key,
    required this.usuario,
  });


  @override
  State<TelaOutroPerfil> createState() => _TelaOutroPerfilState();
}

class _TelaOutroPerfilState extends State<TelaOutroPerfil> {
  late List<_Cards> cards;
  late String exibirDias;
  late String exibirVidas;
  late String fotoSelecionada;
  late Color corFundo;

  Future abrirLink({
    required String url,
  }) async {
    Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Erro ao abrir link",
          conteudo: "Link não abriu. Tente novamente mais tarde!"
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fotoSelecionada = 'assets/images/perfil/${widget.usuario!['foto']}';
    corFundo = Color(int.parse("0xFF${widget.usuario!['cor']}"));
    exibirDias = widget.usuario!['ofensiva'] == 1 ? "dia" : "dias";
    exibirVidas = widget.usuario!['vidas'] == 1 ? "vida" : "vidas";
    cards = [
      _Cards(imagePath: 'assets/images/icone/icone-github.png', titulo: '${widget.usuario!['xp']} XP', subtitulo: 'Quantidade de XP'),
      _Cards(imagePath: 'assets/images/icone/icone-instagram.png', titulo: '${widget.usuario!['ofensiva']} $exibirDias', subtitulo: 'Dias de ofensiva'),
      _Cards(imagePath: 'assets/images/icone/icone-linkedin.png', titulo: '${widget.usuario!['vidas']} $exibirVidas', subtitulo: 'Quantidade de vidas'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil de ${widget.usuario!['nome']}",
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Foto circular + dois botões nas laterais
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xAA1CB0F6),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(5, 13),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: corFundo,
                        child: ClipOval(
                          child: Image.asset(
                            fotoSelecionada,
                            height: 130,
                            width: 130,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // 2) Texto ao lado da foto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.usuario!["nome"],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('@${widget.usuario!["username"]}', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            Divider(
              color: Colors.black,
            ),

            // 3) Botões sociais (círculos azuis)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((widget.usuario!['link_github'] ?? "").isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      abrirLink(url: widget.usuario!['link_github']);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.github,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "GitHub",
                          style: GoogleFonts.quicksand(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if ((widget.usuario!['link_instagram'] ?? "").isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      abrirLink(url: widget.usuario!['link_instagram']);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.pink,
                          size: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Instagram",
                          style: GoogleFonts.quicksand(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if ((widget.usuario!['link_linkedin'] ?? "").isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      abrirLink(url: widget.usuario!['link_linkedin']);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.linkedin,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Linkedin",
                          style: GoogleFonts.quicksand(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            //4) Cards com as informações
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Color(0xFF1CB0F6),
                        width: 1.5,
                      ),
                    ),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xAA1CB0F6),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(5, 13), // sombra pra baixo
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Quadrado da imagem
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              card.imagePath,
                              width: 76,  // largura fixa
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Espaço para os textos
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  card.titulo,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  card.subtitulo,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Cards {
  final String imagePath;
  final String titulo;
  final String subtitulo;
  const _Cards({
    required this.imagePath,
    required this.titulo,
    required this.subtitulo,
  });
}