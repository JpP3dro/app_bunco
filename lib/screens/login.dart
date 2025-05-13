import 'dart:convert';
import 'package:flutter/material.dart';
import '../ip.dart';
import 'package:http/http.dart' as http;
import 'cadastro.dart';


class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  bool _mostrarSenha = false;

  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

  Future<void> fazerLogin() async {
    String ip = obterIP();
    String url = "http://$ip/bunco_testes/login.php";

    try {
      if (_controllerSenha.text == "" || _controllerUsername.text == "") {
        await exibirResultado(titulo: "Campos não preenchidos", conteudo: "Preencha todos os campos!");
      }
      else {
        http.Response res = await http.post(
          Uri.parse(url),
          body: {
            "username": _controllerUsername.text,
            "senha": _controllerSenha.text,
          },
        );
        if (res.statusCode == 200) {
          var user = jsonDecode(res.body);
          if (user.isNotEmpty) {
            await exibirResultado(titulo: "Usuário logado!", conteudo: "Usuário logado com sucesso!");
          }
          else {
            await exibirResultado(titulo: "Não logado!", conteudo: "Usuário ou senha inválidos!");
          }
        }
        else {
          await exibirResultado(titulo: "Algo deu errado!", conteudo: "Erro: ${res.statusCode}");
        }
      }
    } catch (error) {
      await exibirResultado(titulo: "Catch", conteudo: "Erro: $error");
    }
  }

  Future<void> exibirResultado({
    required String titulo,
    required String conteudo,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(conteudo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget é descartado
    _controllerUsername.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text("Fazer login")
        ),
      ),
      body: Stack( // Use Stack para sobrepor widgets
        children: [
          // Conteúdo original centralizado verticalmente
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // A Column ocupa o mínimo de espaço
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _controllerUsername,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Coloque um username:"),
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


          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCadastro()),
                ),
                child: const Text("Não tem um usuário? Crie um agora!"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}