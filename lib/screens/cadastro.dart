import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ip.dart';
import 'login.dart';
import '../tipo_dialogo.dart';
import 'package:page_transition/page_transition.dart';

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
          tipo: TipoDialogo.alerta, titulo: "Campos vazios", conteudo: "Preencha todos os campos!");
    } else {
      try {
        if (username.text.trim().contains(' ')) {
          await exibirResultado(tipo: TipoDialogo.alerta, titulo: "Username com espaço!", conteudo: "A username não pode conter espaços!");
          return;
        }
        final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
        if (!regex.hasMatch(email.text)) {
          await exibirResultado(tipo: TipoDialogo.alerta, titulo: "Email inválido!", conteudo: "Digite um email válido!");
          return;
        }
        String ip = obterIP();
        String url = "http://$ip/Bunco/api/inserir.php";
        var res = await http.post(Uri.parse(url), body: {
          "username": username.text.trim(),
          "nome": nome.text,
          "email": email.text,
          "senha": senha.text
        }).timeout(const Duration(minutes: 1));
        var response = jsonDecode(res.body);
        await exibirResultado(
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
          tipo: TipoDialogo.erro,
          titulo: "Erro crítico",
          conteudo: "Falha na conexão com o servidor! Tente novamente daqui a um tempo.",
        );
      }
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
      body: Center( // Adiciona o Center aqui para centralizar o conteúdo do SingleChildScrollView
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente se houver espaço
              mainAxisSize: MainAxisSize.min, // A Column ocupa o mínimo de espaço vertical necessário
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