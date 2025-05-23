import 'dart:convert';
import 'package:flutter/material.dart';
import '../ip.dart';
import 'package:http/http.dart' as http;
import 'cadastro.dart';
import 'telainicial.dart';
import '../tipo_dialogo.dart';


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
    String url = "http://$ip/Bunco/api/login.php";

    try {
      if (_controllerSenha.text == "" || _controllerLogin.text == "") {
        await exibirResultado(tipo: TipoDialogo.alerta, titulo: "Campos não preenchidos", conteudo: "Preencha todos os campos!");
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
            await exibirResultado(tipo: TipoDialogo.sucesso, titulo: "Usuário logado!", conteudo: "Usuário logado com sucesso!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial(usuario: user)),
            );
          }
          else {
            await exibirResultado(tipo: TipoDialogo.erro, titulo: "Login falho!", conteudo: user["mensagem"]);
          }
        }
        else {
          await exibirResultado(tipo: TipoDialogo.erro, titulo: "Algo deu errado!", conteudo: "Erro: ${res.statusCode}");
        }
      }
    } catch (error) {
      await exibirResultado(tipo: TipoDialogo.erro, titulo: "Catch", conteudo: "Erro: $error");
    }
  }

  Future<void> exibirResultado({
    //required BuildContext context,
    required TipoDialogo tipo,
    required String titulo,
    required String conteudo,
  }) async {
    IconData icone;
    Color cor;

    switch (tipo) {
      case TipoDialogo.sucesso:
        icone = Icons.check_circle;
        cor = Colors.green.shade700;
        break;
      case TipoDialogo.alerta:
        icone = Icons.warning_rounded;
        cor = Colors.amber.shade800;
        break;
      case TipoDialogo.erro:
        icone = Icons.error_outlined;
        cor = Colors.red.shade700;
        break;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          iconPadding: const EdgeInsets.only(top: 20),
          title: Center(
            child: Text(
              titulo,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: cor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                icone,
                size: 48,
                color: cor,
              ),
              const SizedBox(height: 20),
              Text(
                conteudo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: cor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
    );
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
      bottomNavigationBar: Padding( // Adiciona o botão aqui
        padding: const EdgeInsets.all(16.0), // Adiciona padding ao redor do botão
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaCadastro()),
          ),
          child: const Text("Não tem um usuário? Crie um agora!"),
        ),
      ),
    );
  }
}