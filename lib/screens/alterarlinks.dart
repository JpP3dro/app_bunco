import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TelaAlterarLinks extends StatefulWidget {
  final String github;
  final String instagram;
  final String linkedin;
  final String username;
  const TelaAlterarLinks({
    super.key,
    required this.username,
    required this.github,
    required this.instagram,
    required this.linkedin
  });


  @override
  State<TelaAlterarLinks> createState() => _TelaAlterarLinksState();
}

class _TelaAlterarLinksState extends State<TelaAlterarLinks> {
  late TextEditingController _controllerGithub = TextEditingController();
  late TextEditingController _controllerInstagram = TextEditingController();
  late TextEditingController _controllerLinkedin = TextEditingController();
  bool _botaoHabilitado = false;

  Future<void> alterarLinks() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco_testes/api/alterarLinks.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.username,
        "github": _controllerGithub.text.trim(),
        "instagram": _controllerInstagram.text.trim(),
        "linkedin": _controllerLinkedin.text.trim(),
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Links alterados com sucesso!" : "Algo deu errado!",
          conteudo: response["mensagem"]
      );
      if (response["sucesso"] == "true") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp())
        );
      }
    }
    catch(e) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro ao atualizar os links novos",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  void verificarCampos() {
    setState(() {
      _botaoHabilitado = _controllerGithub.text.trim() != widget.github
          || _controllerInstagram.text.trim() != widget.instagram
          || _controllerLinkedin.text.trim() != widget.linkedin;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerGithub = TextEditingController(text: widget.github);
    _controllerInstagram = TextEditingController(text: widget.instagram);
    _controllerLinkedin = TextEditingController(text: widget.linkedin);
    _controllerGithub.addListener(verificarCampos);
    _controllerInstagram.addListener(verificarCampos);
    _controllerLinkedin.addListener(verificarCampos);
  }

  @override
  void dispose() {
    _controllerGithub.dispose();
    _controllerInstagram.dispose();
    _controllerLinkedin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adiconar ou alterar links",
          style: GoogleFonts.baloo2(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerGithub,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Coloque o seu link do GitHub:"),
                    //icon: FaIcon(FontAwesomeIcons.github),
                    icon: Image(
                      image: AssetImage("assets/images/icone/icone-github.png"),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerInstagram,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Coloque o seu link do Instagram:"),
                    //icon: FaIcon(FontAwesomeIcons.instagram),
                    icon: Image(
                      image: AssetImage("assets/images/icone/icone-instagram.png"),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _controllerLinkedin,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Coloque o seu link do Linkedin:"),
                    //icon: FaIcon(FontAwesomeIcons.linkedin),
                    icon: Image(
                      image: AssetImage("assets/images/icone/icone-linkedin.png"),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _botaoHabilitado ? () {
              alterarLinks();
            } : null,
            label: Text(
              "Clique aqui para alterar os links",
              style: GoogleFonts.baloo2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _botaoHabilitado ? Colors.blue : const Color(0x2196F3A8),
            ),
          ),
        ),
      ),
    );
  }
}