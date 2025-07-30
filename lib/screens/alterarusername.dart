import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../uteis/dialogo.dart';
import '../uteis/ip.dart';
import '../uteis/tipo_dialogo.dart';

Future<void> TelaAlterarUsername({
  required BuildContext context,
  required String username,
  required int id,
}) {
  TextEditingController controllerUsername = TextEditingController(text: username);
  bool botaoPressionado = false;
  bool botaoHabilitado = false;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF333333),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) {
            void validarCampo() {
              final novoEstado = controllerUsername.text.trim().isNotEmpty &&
                  controllerUsername.text != username &&
                  controllerUsername.text.trim().length >= 4;

              if (botaoHabilitado != novoEstado) {
                setState(() {
                  botaoHabilitado = novoEstado;
                });
              }
            }
            controllerUsername.addListener(validarCampo);

            return Column(
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
                      const SizedBox(width: 20),
                      Text(
                        'Alterar Username',
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

                // ======== 2) CAMPO DE TEXTO ========
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    cursorColor: Color(0xFF1cB0F6),
                    controller: controllerUsername,
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
                      labelText: "Coloque o seu novo username:",
                      labelStyle: GoogleFonts.baloo2(
                          color: Color(0xFF878787),
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Color(0xFF1CB0F6),
                      ),
                    ),
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
                        _alterarUsername(context, id, controllerUsername.text.trim());
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
                            "Alterar Username",
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
            );
          },
        ),
      );
    },
  );
}

Future<void> _alterarUsername(BuildContext context, int id, String novoUsername) async {
  try {
    String ip = obterIP();
    String url = "http://$ip/bunco/api/alterarUsername.php";
    var res = await http.post(Uri.parse(url), body: {
      "usernamenovo": novoUsername,
      "id": id.toString()
    }).timeout(const Duration(minutes: 1));

    var response = jsonDecode(res.body);
    await exibirResultado(
        context: context,
        tipo: response["sucesso"] == "true" ? TipoDialogo.sucesso : TipoDialogo.erro,
        titulo: response["sucesso"] == "true" ? "Username alterado com sucesso!" : "Algo deu errado!",
        conteudo: response["mensagem"]
    );

    if (response["sucesso"] == "true") {
      // Recarrega o app
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
        titulo: "Erro ao cadastrar o username novo",
        conteudo: e.toString()
    );
  }
}