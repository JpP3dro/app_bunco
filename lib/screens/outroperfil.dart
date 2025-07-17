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
    fotoSelecionada = 'assets/images/perfil/${widget.usuario!['foto']}.png';
    corFundo = Color(int.parse("0xFF${widget.usuario!['cor']}"));
    exibirDias = widget.usuario!['ofensiva'] == 1 ? "dia" : "dias";
    exibirVidas = widget.usuario!['vidas'] == 1 ? "vida" : "vidas";
    cards = [
      _Cards(imagePath: 'assets/images/icone/icone-xp.png', titulo: '${widget.usuario!['xp']} XP', subtitulo: 'Quantidade de XP'),
      _Cards(imagePath: 'assets/images/icone/icone-ofensiva.png', titulo: '${widget.usuario!['ofensiva']} $exibirDias', subtitulo: 'Dias de ofensiva'),
      _Cards(imagePath: 'assets/images/icone/icone-vida.png', titulo: '${widget.usuario!['vidas']} $exibirVidas', subtitulo: 'Quantidade de vidas'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D141F),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF1CB0F6), size: 30,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF0D141F),
        title: Text(
          "Perfil de ${widget.usuario!['nome']}",
          style: GoogleFonts.baloo2(
            color: Color(0xFFB0C2DE),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1) Foto circular
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: corFundo,
                      child: ClipOval(
                        child: Image.asset(
                          fotoSelecionada,
                          height: 160,
                          width: 160,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // 2) Texto ao lado da foto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.usuario!["nome"],
                        style: GoogleFonts.baloo2(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@${widget.usuario!["username"]}',
                        style: GoogleFonts.baloo2(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF586892)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Divider(
                color: Color(0xFF1A263D),
                thickness: 3,
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
                            color: Color(0xFF1CB0F6),
                            size: 40,
                          ),
                          /*const SizedBox(height: 4),
                          Text(
                            "GitHub",
                            style: GoogleFonts.quicksand(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),*/
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
                            color: Color(0xFF1CB0F6),
                            size: 40,
                          ),
                          /*const SizedBox(height: 4),
                          Text(
                            "Instagram",
                            style: GoogleFonts.quicksand(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),*/
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
                            color: Color(0xFF1CB0F6),
                            size: 40,
                          ),
                          /*const SizedBox(height: 4),
                          Text(
                            "Linkedin",
                            style: GoogleFonts.quicksand(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),*/
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 90,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF1F2433),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Quadrado da imagem
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                card.imagePath,
                                width: 100,
                                height: 150,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    card.titulo,
                                    style: GoogleFonts.baloo2(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: index == 0 ? Color(0xFF9069CD) : index == 1 ? Color(0xFFFFC800) : Color(0xFFEA2B2B)
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    card.subtitulo,
                                    style: GoogleFonts.baloo2(
                                        fontSize: 16,
                                        color: Color(0xFF586892),
                                        fontWeight: FontWeight.w700
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