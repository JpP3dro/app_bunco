import 'package:app_bunco/main.dart';
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/ip.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaAlterarNome extends StatefulWidget {
  final String nome;
  final String username;
  const TelaAlterarNome({
    super.key,
    required this.nome,
    required this.username
  });


  @override
  State<TelaAlterarNome> createState() => _TelaAlterarNomeState();
}

class _TelaAlterarNomeState extends State<TelaAlterarNome> {
  late TextEditingController _controllerNome;
  bool _botaoHabilitado = false;

  Future<void> alterarNome() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco/api/alterarNome.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.username,
        "nomenovo": _controllerNome.text.trim()
      }).timeout(const Duration(minutes: 1));
    var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Nome alterado com sucesso!" : "Algo deu errado!",
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
          titulo: "Erro ao cadastrar o nome novo",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerNome = TextEditingController(text: widget.nome);

    _controllerNome.addListener(() {
      setState(() {
        _botaoHabilitado = _controllerNome.text
            .trim()
            .isNotEmpty && _controllerNome.text != widget.nome &&
            _controllerNome.text
                .trim()
                .length >= 4;
      });
    });
  }

  @override
  void dispose() {
    _controllerNome.dispose(); // Libera a memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Alterar nome",
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
                    controller: _controllerNome,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Coloque o seu novo nome:"),
                      icon: Icon(Icons.badge_outlined),
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
              alterarNome();
        } : null,
            label: Text(
                "Clique aqui para alterar o nome",
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