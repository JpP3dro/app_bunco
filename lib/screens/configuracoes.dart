import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_bunco/screens/alterarnome.dart';
import 'package:app_bunco/screens/alterarusername.dart';
import 'package:app_bunco/screens/alteraremail.dart';
import 'package:app_bunco/screens/alterarsenha.dart';
import 'package:app_bunco/screens/alterarlinks.dart';
import 'package:app_bunco/main.dart';
import 'package:app_bunco/uteis/ip.dart';
import 'package:http/http.dart' as http;
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';

class TelaConfiguracoes extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const TelaConfiguracoes({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
  }
  
  class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
    late List<Map<String, dynamic>> opcoes;

    Future<void> certeza({
      required String titulo,
      required IconData icone,
      required String acao,
    }) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Row(
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.baloo2(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8,),
                Icon(icone),
              ],
            ),
            content: Text(
                "Você tem certeza?",
              style: GoogleFonts.workSans(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      child: const Row(
                        children: [
                          Text("Sim"),
                          Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (acao == "sair") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp())
                          );
                        }
                        else if (acao == "excluir") {
                          excluirConta();
                        }
                      },
                    ),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Row(
                      children: [
                        Text("Não"),
                        Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    Future<void> excluirConta() async {
      try {
        String ip = obterIP();
        String url = "http://$ip/bunco/api/excluir.php";
        var res = await http.post(Uri.parse(url), body: {
          "username": widget.usuario["username"]
        }).timeout(const Duration(minutes: 1));
        var response = jsonDecode(res.body);
        await exibirResultado(context: context,
            tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
            titulo: response["sucesso"] == "true" ? "Sucesso!" : "Algo deu errado!",
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
        await exibirResultado(context: context,
            tipo: TipoDialogo.erro,
            titulo: "Erro do servidor",
            conteudo: "Talvez seja um sinal para você continuar com a gente"
        );
      }
    }

    @override
    void initState() {
      super.initState();
      opcoes = [
        {"label": "Alterar o nome", "page": TelaAlterarNome(nome: widget.usuario["nome"], username: widget.usuario["username"],)},
        {"label": "Alterar o username", "page": TelaAlterarUsername(id: widget.usuario["id"], username: widget.usuario["username"],)},
        {"label": "Alterar o email", "page": TelaAlterarEmail(email: widget.usuario["email"], username: widget.usuario["username"],)},
        {"label": "Alterar a senha", "page": TelaAlterarSenha(username: widget.usuario["username"],)},
        {"label": "Adicionar links para as redes sociais", "page": TelaAlterarLinks(
          username: widget.usuario["username"],
          github: widget.usuario["link_github"] ?? "",
           instagram: widget.usuario["link_instagram"] ?? "",
          linkedin: widget.usuario["link_linkedin"] ?? "",
        )},
      ];
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "Configurações",
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: opcoes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => opcoes[index]['page']),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.vertical(
                        top: index == 0 ? const Radius.circular(20) : const Radius.circular(0),
                        bottom: index == 4 ? const Radius.circular(20) : const Radius.circular(0),
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opcoes[index]['label'],
                        style: GoogleFonts.baloo2(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      certeza(titulo: "Sair da conta", icone: Icons.logout, acao: "sair",);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                    label: Text(
                        "Sair da conta",
                      style: GoogleFonts.baloo2(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      certeza(titulo: "Excluir a conta", icone: Icons.delete_forever, acao: "excluir",);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                        "Excluir a conta",
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  }