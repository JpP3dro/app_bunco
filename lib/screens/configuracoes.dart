import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_bunco/main.dart';
import 'package:app_bunco/uteis/ip.dart';
import 'package:http/http.dart' as http;
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import '../uteis/alterar_ip.dart';
import 'alterarnome.dart' show TelaAlterarNome;
import 'alterarusername.dart' show TelaAlterarUsername;
import 'alteraremail.dart' show TelaAlterarEmail;
import 'alterarsenha.dart' show TelaAlterarSenha;
import 'alterarlinks.dart' show TelaAlterarLinks;

class TelaConfiguracoes extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final bool parametroModoEscuro;
  final void Function(bool) onModoEscuroChanged;
  const TelaConfiguracoes({
    super.key,
    required this.usuario,
    required this.parametroModoEscuro,
    required this.onModoEscuroChanged,
  });

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
  }
  
  class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
    late bool _botaoClaroPressionado;
    late List<Map<String, dynamic>> opcoes;
    late bool modoEscuro;
    late bool _botaoEscuroPressionado;

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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                              (route) => false
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
      modoEscuro = widget.parametroModoEscuro;
      _botaoClaroPressionado = !modoEscuro;
      _botaoEscuroPressionado = modoEscuro;
      opcoes = [
        {"label": "Alterar o nome", "tipo": "nome"},
        {"label": "Alterar o username", "tipo": "username"},
        {"label": "Alterar o email", "tipo": "email"},
        {"label": "Alterar a senha", "tipo": "senha"},
        {"label": "Adicionar links para redes sociais", "tipo": "links"},
      ];
    }

    void _abrirDialogo(String tipo) async {
      String? informacaoAlterada;
      List<String>? linksAlterados;
      switch (tipo) {
        case "nome":
          informacaoAlterada = await TelaAlterarNome(
            context: context,
            nome: widget.usuario["nome"],
            username: widget.usuario["username"],
          );
          if (informacaoAlterada != null) {
            setState(() {
              widget.usuario["nome"] = informacaoAlterada;
            });
          }
          break;
        case "username":
          informacaoAlterada = await TelaAlterarUsername(
            context: context,
            username: widget.usuario["username"],
          );
          if (informacaoAlterada != null) {
            setState(() {
              widget.usuario["username"] = informacaoAlterada;
            });
          }
          break;
        case "email":
          informacaoAlterada = await TelaAlterarEmail(
            context: context,
            email: widget.usuario["email"],
            username: widget.usuario["username"],
          );
          if (informacaoAlterada != null) {
            setState(() {
              widget.usuario["email"] = informacaoAlterada;
            });
          }
          break;
        case "senha":
          TelaAlterarSenha(
            context: context,
            username: widget.usuario["username"],
          );
          break;
        case "links":
          linksAlterados = await TelaAlterarLinks(
            context: context,
            username: widget.usuario["username"],
            github: widget.usuario["link_github"] ?? "",
            instagram: widget.usuario["link_instagram"] ?? "",
            linkedin: widget.usuario["link_linkedin"] ?? "",
          );
          if (linksAlterados != null) {
            widget.usuario["link_github"] = linksAlterados[0];
            widget.usuario["link_instagram"] = linksAlterados[1];
            widget.usuario["link_linkedin"] = linksAlterados[2];
          }
          break;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF29A2DB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF29A2DB),
        title: Icon(
          Icons.settings,
          color: modoEscuro ? Color(0xFF0D141F) : Colors.white,
          size: 60,
          shadows: [
            Shadow(
              color: Color(0x55000000),
              offset: Offset(4, 4),
              blurRadius: 12
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Color(0x33FFFFFF),),
              onPressed: () {
                dialogoAlterarIP(context, setState);
              },
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            kToolbarHeight,
        decoration: BoxDecoration(
          color: modoEscuro ? Color(0xFF0D141F) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(70),
            topRight: Radius.circular(70),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Configurações",
                  style: GoogleFonts.baloo2(
                    fontSize: 25,
                    color: Color(0xFF29A2DB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTapDown: (_) => setState(() => _botaoClaroPressionado = true),
                          onTapUp: (_) {
                            setState(() => _botaoEscuroPressionado = false);
                            setState(() {
                              modoEscuro = false;
                              widget.onModoEscuroChanged(modoEscuro);
                            });
                          },
                          onTapCancel: () => setState(() => _botaoClaroPressionado = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 70),
                            transform: Matrix4.identity()
                              ..translate(0.0, _botaoClaroPressionado ? 5.0 : 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: _botaoClaroPressionado
                                  ? null : !modoEscuro ? null
                                  : [
                                BoxShadow(
                                  color: Color(0xFF2C4168),
                                  offset: const Offset(2.5, 2.5),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/icone/icone-claro.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Claro",
                          style: GoogleFonts.baloo2(
                            color: modoEscuro ? Color(0xFF586892) : Color(0xFFABABAB),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        GestureDetector(
                          onTapDown: (_) => setState(() => _botaoEscuroPressionado = true),
                          onTapUp: (_) {
                            setState(() => _botaoClaroPressionado = false);
                            setState(() {
                              modoEscuro = true;
                              widget.onModoEscuroChanged(modoEscuro);
                            });
                          },
                          onTapCancel: () => setState(() => _botaoEscuroPressionado = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 70),
                            transform: Matrix4.identity()
                              ..translate(0.0, _botaoEscuroPressionado ? 5.0 : 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: _botaoEscuroPressionado
                                  ? null
                                  : modoEscuro ? null : [
                                BoxShadow(
                                  color: Color(0xFF2C4168),
                                  offset: const Offset(2.5, 2.5),
                                ),
                              ],
                            ),
                            child: Image.asset(
                                'assets/images/icone/icone-escuro.png',
                                width: 80,
                                height: 80,
                              ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Escuro",
                          style: GoogleFonts.baloo2(
                            color: modoEscuro ? Color(0xFF586892) : Color(0xFFABABAB),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: opcoes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => _abrirDialogo(opcoes[index]['tipo']),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: modoEscuro ? Color(0xFF1A263D) : Color(0xFFE5E5E5), width: 3),
                              borderRadius: BorderRadius.vertical(
                                top: index == 0
                                    ? const Radius.circular(30)
                                    : const Radius.circular(0),
                                bottom: index == 4
                                    ? const Radius.circular(30)
                                    : const Radius.circular(0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  opcoes[index]['label'],
                                  style: GoogleFonts.baloo2(
                                    color: modoEscuro ? Colors.white : Color(0xFF7A7A7A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF1CB0F6),
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Botões fixos
                    Positioned(
                      bottom: 10,
                      left: 15,
                      right: 15,
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              certeza(
                                titulo: "Sair da conta",
                                icone: Icons.logout,
                                acao: "sair",
                              );
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
                              certeza(
                                titulo: "Excluir a conta",
                                icone: Icons.delete_forever,
                                acao: "excluir",
                              );
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }