import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';
import '../uteis/dialogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../uteis/escolherfoto.dart';
import '../uteis/escolhercor.dart';

class TelaPerfil extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const TelaPerfil({
    super.key,
    required this.usuario,
  });


  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
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

  Future<void> alterarFoto() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco/api/alterarFoto.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.usuario['username'],
        "foto": widget.usuario['foto']
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Foto alerada com sucesso!" : "Algo deu errado!",
          conteudo: response["mensagem"]
      );
    }
    catch(e) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro ao colocar a foto nova no servidor",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  Future<void> alterarCor() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco/api/alterarCor.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.usuario['username'],
        "cor": widget.usuario['cor']
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Cor alerada com sucesso!" : "Algo deu errado!",
          conteudo: response["mensagem"]
      );
    }
    catch(e) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro ao colocar a cor nova no servidor",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fotoSelecionada = 'assets/images/perfil/${widget.usuario['foto']}';
    corFundo = Color(int.parse("0xFF${widget.usuario['cor']}"));
    exibirDias = widget.usuario['ofensiva'] == 1 ? "dia" : "dias";
    exibirVidas = widget.usuario['vidas'] == 1 ? "vida" : "vidas";
    cards = [
      _Cards(imagePath: 'assets/images/icone/icone-github.png', titulo: '${widget.usuario['xp']} XP', subtitulo: 'Quantidade de XP'),
      _Cards(imagePath: 'assets/images/icone/icone-instagram.png', titulo: '${widget.usuario['ofensiva']} $exibirDias', subtitulo: 'Dias de ofensiva'),
      _Cards(imagePath: 'assets/images/icone/icone-linkedin.png', titulo: '${widget.usuario['vidas']} $exibirVidas', subtitulo: 'Quantidade de vidas'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Meu Perfil",
          style: GoogleFonts.baloo2(
            color: Colors.black,
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
                      Positioned(
                        left: -10,
                        bottom: -25,
                        child: IconButton(
                          onPressed: () async {
                            final escolha = await mostrarSeletorDeFotoDePerfil(
                                context,
                                fotoAtual: fotoSelecionada,
                                corFundo: corFundo
                            );
                            if (escolha != null) {
                              setState(() {
                                fotoSelecionada = escolha;
                                widget.usuario['foto'] = fotoSelecionada.replaceAll('assets/images/perfil/', "");
                              });
                              alterarFoto();
                            }
                          },
                          icon: const Icon(Icons.camera_alt),
                          color: Colors.white,
                          iconSize: 24,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -25,
                        child: IconButton(
                          onPressed: () async {
                            if (fotoSelecionada == "assets/images/perfil/undefined.png") {
                              await exibirResultado(
                                  context: context,
                                  tipo: TipoDialogo.alerta,
                                  titulo: "Selecione uma foto!",
                                  conteudo: "Coloque uma foto antes de alterar a cor de fundo!");
                              return;
                            }
                            final escolha = await mostrarSeletorDeCor(
                              context,
                              fotoAtual: fotoSelecionada,
                              corAtual: corFundo,
                            );
                            if (escolha != null) {
                              setState(() {
                                int teste = escolha.toARGB32();
                                corFundo = escolha;
                                widget.usuario['cor'] = teste.toRadixString(16).substring(2);
                              });
                              alterarCor();
                            }
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          iconSize: 24,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
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
                      Text(widget.usuario["nome"],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('@${widget.usuario["username"]}', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                  if ((widget.usuario['link_github'] ?? "").isNotEmpty) ...[
                    TextButton(
                      onPressed: () {
                        abrirLink(url: widget.usuario['link_github']);
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
                  if ((widget.usuario['link_instagram'] ?? "").isNotEmpty) ...[
                    TextButton(
                      onPressed: () {
                        abrirLink(url: widget.usuario['link_instagram']);
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
                  if ((widget.usuario['link_linkedin'] ?? "").isNotEmpty) ...[
                    TextButton(
                      onPressed: () {
                        abrirLink(url: widget.usuario['link_linkedin']);
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