import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> TelaAlterarLinks({
  required BuildContext context,
  required String username,
  required String github,
  required String instagram,
  required String linkedin,
}) {

  final TextEditingController controllerGithub = TextEditingController(text: github);
  final TextEditingController controllerInstagram = TextEditingController(text: instagram);
  final TextEditingController controllerLinkedin = TextEditingController(text: linkedin);
  bool botaoPressionado = false;
  bool botaoHabilitado = false;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void validarCampos() {
            final novoEstado = controllerGithub.text.trim() != github ||
                controllerInstagram.text.trim() != instagram ||
                controllerLinkedin.text.trim() != linkedin;
            if (botaoHabilitado != novoEstado) {
              setState(() {
                botaoHabilitado = novoEstado;
              });
            }
          }
          controllerGithub.addListener(validarCampos);
          controllerInstagram.addListener(validarCampos);
          controllerLinkedin.addListener(validarCampos);

          return Dialog(
            backgroundColor: const Color(0xFF333333),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ======== 1) BARRA DE TÍTULO ========
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4D4D4D),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFF4B4B),
                          radius: 7,
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFB100),
                          radius: 7,
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF58CC02),
                          radius: 7,
                        ),
                        const SizedBox(width: 50),
                        Text(
                          'Alterar Links',
                          style: GoogleFonts.baloo2(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======== 2) CAMPOS DE LINKS ========
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Campo GitHub
                        TextFormField(
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerGithub,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D4D4D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF1CB0F6),
                                width: 2,
                              ),
                            ),
                            labelText: "Link do GitHub:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.github,
                              color: Color(0xFF1CB0F6),
                              size: 30,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Campo Instagram
                        TextFormField(
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerInstagram,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D4D4D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF1CB0F6),
                                width: 2,
                              ),
                            ),
                            labelText: "Link do Instagram:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.instagram,
                              color: Color(0xFF1CB0F6),
                              size: 30,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Campo LinkedIn
                        TextFormField(
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerLinkedin,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D4D4D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF1CB0F6),
                                width: 2,
                              ),
                            ),
                            labelText: "Link do LinkedIn:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.linkedin,
                              color: Color(0xFF1CB0F6),
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======== 3) BOTÃO DE CONFIRMAR ========
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTapDown: (_) {
                        if (botaoHabilitado) {
                          setState(() => botaoPressionado = true);
                        }
                      },
                      onTapUp: (_) {
                        setState(() => botaoPressionado = false);
                        if (botaoHabilitado) {
                          _alterarLinks(
                              context,
                              username,
                              controllerGithub.text.trim(),
                              controllerInstagram.text.trim(),
                              controllerLinkedin.text.trim()
                          );
                        }
                      },
                      onTapCancel: () => setState(() => botaoPressionado = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(0.0, botaoPressionado ? 5.0 : 0.0),
                        decoration: BoxDecoration(
                          color: botaoHabilitado ? const Color(0xFF1CB0F6) : Color(0xFF505050),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: botaoPressionado || !botaoHabilitado
                              ? null
                              : [
                            BoxShadow(
                              color: const Color(0xFF1453A3),
                              offset: const Offset(6, 6),
                              blurRadius: 0,
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Alterar Links",
                              style: GoogleFonts.baloo2(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: botaoHabilitado ? Colors.white : Color(0xFF333333),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _alterarLinks(
    BuildContext context,
    String username,
    String github,
    String instagram,
    String linkedin
    ) async {
  try {
    // Verificar os links com regex
    final regexGithub = RegExp(r'^https:\/\/(www\.)?github\.com\/[a-zA-Z0-9_-]+\/?$');
    final regexInstagram = RegExp(r'^https:\/\/(www\.)?instagram\.com\/[a-zA-Z0-9._]+\/?$');
    final regexLinkedin = RegExp(
      r"^https:\/\/(www\.)?linkedin\.com\/in\/[a-zA-Z0-9À-ÿ\-_%]+\/?$",
      caseSensitive: false,
    );

    if (!regexGithub.hasMatch(github)) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Github inválido!",
          conteudo: "O link que você colocou no Github está inválido!"
      );
      return;
    }
    else if (!regexInstagram.hasMatch(instagram)) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Instagram inválido!",
          conteudo: "O link que você colocou no Instagram está inválido!"
      );
      return;
    }
    else if (!regexLinkedin.hasMatch(linkedin)) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Link do Linkedin inválido!",
          conteudo: "O link que você colocou no Linkedin está inválido!"
      );
      return;
    }

    String ip = obterIP();
    String url = "http://$ip/bunco/api/alterarLinks.php";
    var res = await http.post(Uri.parse(url), body: {
      "username": username,
      "github": github,
      "instagram": instagram,
      "linkedin": linkedin,
    }).timeout(const Duration(minutes: 1));

    var response = jsonDecode(res.body);
    await exibirResultado(
        context: context,
        tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
        titulo: response["sucesso"] == "true" ? "Links alterados com sucesso!" : "Algo deu errado!",
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
        titulo: "Erro ao atualizar os links novos",
        conteudo: "Tente de novo daqui a pouco!"
    );
  }
}