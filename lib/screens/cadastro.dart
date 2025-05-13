import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ip.dart';
import 'login.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  TextEditingController nome = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  bool _mostrarSenha = false;

  Future<void> inserir() async {
    if (!(nome.text.isNotEmpty && username.text.isNotEmpty &&
        email.text.isNotEmpty && senha.text.isNotEmpty)) {
      await exibirResultado(
          titulo: "Campos vazios", conteudo: "Preencha todos os campos!");
    } else {
      try {
        String ip = obterIP();
        String url = "http://$ip/bunco_testes/inserir.php";
        var res = await http.post(Uri.parse(url), body: {
          "username": username.text,
          "nome": nome.text,
          "email": email.text,
          "senha": senha.text
        });
        var response = jsonDecode(res.body);
        await exibirResultado(
          titulo: response["sucesso"] == "true"
              ? "Sucesso!"
              : "Erro!",
          conteudo: response["sucesso"] == "true"
              ? "Registro salvo com sucesso!"
              : "Falha no cadastro",
        );
      }
      catch (e) {
        await exibirResultado(
          titulo: "Erro crítico",
          conteudo: "Falha na conexão: ${e.toString()}",
        );
      }
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
    nome.dispose();
    username.dispose();
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Center(
              child: Text('Criar um novo usuário'),
            ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: nome,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Coloque um nome:"),
                icon: Icon(Icons.person),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Coloque um nome de usuário:"),
                icon: Icon(Icons.switch_account),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Coloque um email:"),
                icon: Icon(Icons.mark_email_read),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: senha,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text("Coloque uma senha:"),
                  icon: const Icon(Icons.password),
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _mostrarSenha == false ? Icons.visibility_off : Icons
                          .visibility, color: Colors.blue,),
                    onTap: () {
                      setState(() {
                        _mostrarSenha = !_mostrarSenha;
                      });
                    },
                  )
              ),
              obscureText: _mostrarSenha == false ? true : false,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                inserir();
              },
              child: const Text("Clique para criar um novo usuário"),
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
            MaterialPageRoute(builder: (context) => const TelaLogin()),
          ),
          child: const Text("Já tem um usuário? Clique aqui para logar!"),
        ),
      ),
    ),
          ],
      ),
    );
  }
}