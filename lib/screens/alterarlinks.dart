import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    if (!await verificarLinks()) return;
    try {
      String ip = obterIP();
      String url = "http://$ip//api/alterarLinks.php";
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

  Future<bool> verificarLinks() async {
    final regexGithub = RegExp(r'^https:\/\/(www\.)?github\.com\/[a-zA-Z0-9_-]+\/?$');
    final regexInstagram = RegExp(r'^https:\/\/(www\.)?instagram\.com\/[a-zA-Z0-9._]+\/?$');
    final regexLinkedin = RegExp(r'^https:\/\/(www\.)?linkedin\.com\/in\/[a-zA-Z0-9-_%]+\/?$');
    if (!regexGithub.hasMatch(_controllerGithub.text.trim())) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Github inválido!",
          conteudo: "O link que você colocou no Github está inválido!");
      return false;
    }
    else if (!regexInstagram.hasMatch(_controllerInstagram.text.trim())) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Instagram inválido!",
          conteudo: "O link que você colocou no Instagram está inválido!");
      return false;
    }
    else if (!regexLinkedin.hasMatch(_controllerLinkedin.text.trim())) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Linkedin inválido!",
          conteudo: "O link que você colocou no Linkedin está inválido!");
      return false;
    }
    return true;
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
                    icon: Icon(
                      FontAwesomeIcons.github,
                      color: Colors.black,
                      size: 30,
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
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.pink,
                      size: 30,
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
                    icon: Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blueAccent,
                      size: 30,
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