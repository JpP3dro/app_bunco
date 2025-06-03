import 'dart:convert';
import 'package:app_bunco/uteis/ip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/tipo_dialogo.dart';

class TelaAlterarSenha extends StatefulWidget {
  final String username;
  const TelaAlterarSenha({
    super.key,
    required this.username
  });


  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  final TextEditingController _controllerSenhaAtual = TextEditingController();
  final TextEditingController _controllerSenhaNova = TextEditingController();
  final TextEditingController _controllerSenhaConfirmada = TextEditingController();
  bool _botaoHabilitado = false;
  bool _mostrarSenhaAtual = false;
  bool _mostrarSenhaNova = false;
  bool _mostrarSenhaConfirmada = false;

  Future<void> alterarSenha() async {
    try {
      if (_controllerSenhaAtual.text.trim() == _controllerSenhaNova.text.trim()) {
        await exibirResultado(
            context: context,
            tipo: TipoDialogo.alerta,
            titulo: "Senhas iguais!",
            conteudo: "Você colocou a mesma senha tanto no campo de senha atual quanto no campo de senha nova!");
        return;
      }
      if (_controllerSenhaNova.text.trim() != _controllerSenhaConfirmada.text.trim()) {
        await exibirResultado(
            context: context,
            tipo: TipoDialogo.alerta,
            titulo: "Senhas diferentes!",
            conteudo: "Você colocou senhas diferentes nos campos de senha nova!");
        return;
      }
      String ip = obterIP();
      String url = "http://$ip/bunco/api/alterarSenha.php";
      var res = await http.post(Uri.parse(url), body: {
        "username": widget.username,
        "senhanova": _controllerSenhaNova.text.trim(),
        "senhaatual": _controllerSenhaAtual.text.trim()
      }).timeout(const Duration(minutes: 1));
      var response = jsonDecode(res.body);
      await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
          titulo: response["sucesso"] == "true" ? "Senha alterada com sucesso!" : "Algo deu errado!",
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
          titulo: "Erro ao cadastrar a senha nova",
          conteudo: "Tente de novo daqui a pouco!"
      );
    }
  }

  void verificarCampos() {
    setState(() {
      _botaoHabilitado = _controllerSenhaAtual.text.trim().isNotEmpty
          && _controllerSenhaNova.text.trim().isNotEmpty
          && _controllerSenhaConfirmada.text.trim().isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerSenhaAtual.addListener(verificarCampos);
    _controllerSenhaNova.addListener(verificarCampos);
    _controllerSenhaConfirmada.addListener(verificarCampos);
    }



  @override
  void dispose() {
    // Limpa os controladores quando o widget é descartado
    _controllerSenhaAtual.dispose();
    _controllerSenhaNova.dispose();
    _controllerSenhaConfirmada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alterar a senha",
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
                    controller: _controllerSenhaAtual,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Coloque a senha atual:"),
                        icon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _mostrarSenhaAtual == false ? Icons.visibility_off : Icons
                                .visibility, color: Colors.blue,),
                          onTap: () {
                            setState(() {
                              _mostrarSenhaAtual = !_mostrarSenhaAtual;
                            });
                          },
                        )
                    ),
                    obscureText: _mostrarSenhaAtual == false ? true : false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerSenhaNova,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Coloque a nova senha:"),
                        icon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _mostrarSenhaNova == false ? Icons.visibility_off : Icons
                                .visibility, color: Colors.blue,),
                          onTap: () {
                            setState(() {
                              _mostrarSenhaNova = !_mostrarSenhaNova;
                            });
                          },
                        )
                    ),
                    obscureText: _mostrarSenhaNova == false ? true : false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerSenhaConfirmada,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Confirme a nova senha:"),
                        icon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _mostrarSenhaConfirmada == false ? Icons.visibility_off : Icons
                                .visibility, color: Colors.blue,),
                          onTap: () {
                            setState(() {
                              _mostrarSenhaConfirmada = !_mostrarSenhaConfirmada;
                            });
                          },
                        )
                    ),
                    obscureText: _mostrarSenhaConfirmada == false ? true : false,
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
              Icons.password,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _botaoHabilitado ? () {
              alterarSenha();
            } : null,
            label: Text(
              "Clique aqui para alterar a senha",
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