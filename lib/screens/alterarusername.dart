import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';

class TelaAlterarUsername extends StatefulWidget {
  final String username;
  final int id;
  const TelaAlterarUsername({
    super.key,
    required this.username,
    required this.id
  });


  @override
  State<TelaAlterarUsername> createState() => _TelaAlterarUsernameState();
}

class _TelaAlterarUsernameState extends State<TelaAlterarUsername> {
  late TextEditingController _controllerUsername;
  bool _botaoHabilitado = false;

  Future<void> alterarUsername() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco/api/alterarUsername.php";
      var res = await http.post(Uri.parse(url), body: {
        "usernamenovo": _controllerUsername.text.trim(),
        "id": widget.id.toString()
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Username alterado com sucesso!" : "Algo deu errado!",
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
          conteudo: e.toString()
      );
    }

  }

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController(text: widget.username);

    _controllerUsername.addListener(() {
      setState(() {
        _botaoHabilitado = _controllerUsername.text
            .trim()
            .isNotEmpty && _controllerUsername.text != widget.username &&
            _controllerUsername.text
                .trim()
                .length >= 4;
      });
    });
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alterar username",
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
                  controller: _controllerUsername,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Coloque o seu novo username:"),
                    icon: Icon(Icons.account_circle_outlined),
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
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _botaoHabilitado ? () {
              alterarUsername();
            } : null,
            label: Text(
              "Clique aqui para alterar o username",
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