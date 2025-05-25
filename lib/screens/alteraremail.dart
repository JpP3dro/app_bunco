import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';

class TelaAlterarEmail extends StatefulWidget {
  final String email;
  final String username;
  const TelaAlterarEmail({
    super.key,
    required this.email,
    required this.username
  });


  @override
  State<TelaAlterarEmail> createState() => _TelaAlterarEmailState();
}

class _TelaAlterarEmailState extends State<TelaAlterarEmail> {
  late TextEditingController _controllerEmail;
  bool _botaoHabilitado = false;
  final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");

  Future<void> alterarEmail() async {
    try {
      String ip = obterIP();
      String url = "http://$ip/bunco_testes/api/alterarEmail.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.username,
        "email": _controllerEmail.text.trim()
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Email alterado com sucesso!" : "Algo deu errado!",
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
          titulo: "Erro ao cadastrar o email novo",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController(text: widget.email);

    _controllerEmail.addListener(() {
      setState(() {
        _botaoHabilitado = _controllerEmail.text
            .trim()
            .isNotEmpty && _controllerEmail.text != widget.email &&
            _controllerEmail.text
                .trim()
                .length >= 4 && regex.hasMatch(_controllerEmail.text);
      });
    });
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alterar email",
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
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Coloque o seu novo email:"),
                    icon: Icon(Icons.email),
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
              Icons.email,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _botaoHabilitado ? () {
              alterarEmail();
            } : null,
            label: Text(
              "Clique aqui para alterar o email",
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