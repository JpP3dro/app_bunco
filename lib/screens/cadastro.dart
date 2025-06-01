import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../uteis/ip.dart';
import 'login.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:page_transition/page_transition.dart';
import '../uteis/dialogo.dart';

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
          context: context, tipo: TipoDialogo.alerta, titulo: "Campos vazios", conteudo: "Preencha todos os campos!");
    } else {
      try {
        if (username.text.trim().contains(' ')) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Username com espaço!", conteudo: "A username não pode conter espaços!");
          return;
        }
        final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
        if (!regex.hasMatch(email.text)) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Email inválido!", conteudo: "Digite um email válido!");
          return;
        }
        if (nome.text.trim().length < 4 || username.text.trim().length < 4) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Nome ou username muito pequeno", conteudo: "O nome e o username precisam ter no mínimo 4 caracteres!");
          return;
        }
        String ip = obterIP();
        String url = "http://$ip/bunco/api/cadastrar.php";
        var res = await http.post(Uri.parse(url), body: {
          "username": username.text.trim(),
          "nome": nome.text,
          "email": email.text,
          "senha": senha.text
        }).timeout(const Duration(minutes: 1));
        var response = jsonDecode(res.body);
        await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true"
          ? TipoDialogo.sucesso
          : TipoDialogo.erro,
          titulo: response["sucesso"] == "true"
              ? "Sucesso!"
              : "Erro!",
          conteudo: response["sucesso"] == "true"
              ? "Registro salvo com sucesso!"
              : response["mensagem"],
        );
      }
      catch (e) {
        await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro crítico",
          conteudo: "Falha na conexão com o servidor! Tente novamente daqui a um tempo.",
        );
      }
    }
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
        title: const Center(
          child: Text('Criar um novo usuário'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
              PageTransition(
                child: const TelaLogin(),
                type: PageTransitionType.leftToRight,
                duration: const Duration(milliseconds: 500),
              )
          ),
          child: const Text("Já tem um usuário? Clique aqui para logar!"),
        ),
      ),
    );
  }
}