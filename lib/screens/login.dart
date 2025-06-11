import 'dart:convert';
import 'package:flutter/material.dart';
import '../uteis/ip.dart';
import 'package:http/http.dart' as http;
import 'cadastro.dart';
import 'telainicial.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:page_transition/page_transition.dart';
import '../uteis/dialogo.dart';


class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  bool _mostrarSenha = false;

  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerLogin = TextEditingController();

  Future<void> fazerLogin() async {
    String ip = obterIP();
    String url = "http://$ip/bunco/api/login.php";

    try {
      if (_controllerSenha.text == "" || _controllerLogin.text == "") {
        await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Campos não preenchidos", conteudo: "Preencha todos os campos!");
      }
      else {
        http.Response res = await http.post(
          Uri.parse(url),
          body: {
            "login": _controllerLogin.text,
            "senha": _controllerSenha.text,
          },
        );
        if (res.statusCode == 200) {
          var user = jsonDecode(res.body);
          if (user["sucesso"] == "true") {
            await exibirResultado(context: context, tipo: TipoDialogo.sucesso, titulo: "Usuário logado!", conteudo: "Usuário logado com sucesso!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial(usuario: user)),
            );
          }
          else {
            await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Login falho!", conteudo: user["mensagem"]);
          }
        }
        else {
          await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Algo deu errado!", conteudo: "Erro: ${res.statusCode}");
        }
      }
    } catch (e) {
      await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Erro ao fazer o login", conteudo: "Conexão com o servidor falhou. Tente novamente daqui a pouco!");
    }
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget é descartado
    _controllerLogin.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Mantém a remoção do botão de voltar automático
        title: const Center(
            child: Text("Fazer login")
        ),
      ),
      body: Center( // Para centralizar o SingleChildScrollView
        child: SingleChildScrollView( // Para permitir rolagem se o conteúdo for grande ou o teclado aparecer
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adiciona padding ao redor do formulário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente se houver espaço
              mainAxisSize: MainAxisSize.min, // A Column ocupa o mínimo de espaço
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerLogin,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Coloque um username ou um email:"),
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerSenha,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Coloque uma senha:"),
                      icon: const Icon(Icons.password),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _mostrarSenha == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onTap: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                      ),
                    ),
                    obscureText: _mostrarSenha == false ? true : false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      fazerLogin();
                    },
                    child: const Text("Fazer o login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            context,
              PageTransition(
                child: const TelaCadastro(),
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 500),
              )
          ),
          child: const Text("Não tem um usuário? Crie um agora!"),
        ),
      ),
    );
  }
}