import 'dart:convert';
import 'package:app_bunco/uteis/url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../uteis/dialogo.dart';
import '../uteis/tipo_dialogo.dart';

Future<void> TelaAlterarSenha({
  required BuildContext context,
  required String username,
}) {
  final TextEditingController controllerSenhaAtual = TextEditingController();
  final TextEditingController controllerSenhaNova = TextEditingController();
  final TextEditingController controllerSenhaConfirmada =
      TextEditingController();

  bool mostrarSenhaAtual = false;
  bool mostrarSenhaNova = false;
  bool mostrarSenhaConfirmada = false;
  bool botaoPressionado = false;
  bool botaoHabilitado = false;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF333333),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) {
            void validarCampos() {
              final novoEstado = controllerSenhaAtual.text.trim().isNotEmpty &&
                  controllerSenhaNova.text.trim().isNotEmpty &&
                  controllerSenhaConfirmada.text.trim().isNotEmpty;
              if (botaoHabilitado != novoEstado) {
                setState(() {
                  botaoHabilitado = novoEstado;
                });
              }
            }

            controllerSenhaAtual.addListener(validarCampos);
            controllerSenhaNova.addListener(validarCampos);
            controllerSenhaConfirmada.addListener(validarCampos);

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ======== 1) BARRA DE TÍTULO ========
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4D4D4D),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
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
                          'Alterar Senha',
                          style: GoogleFonts.baloo2(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======== 2) CAMPOS DE SENHA ========
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Senha Atual
                        TextFormField(
                          //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          //buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                          maxLength: 16,
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerSenhaAtual,
                          obscureText: !mostrarSenhaAtual,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
                            labelText: "Senha atual:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                            icon: const Icon(
                              Icons.password,
                              color: Color(0xFF1CB0F6),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarSenhaAtual = !mostrarSenhaAtual;
                                });
                              },
                              child: Icon(
                                mostrarSenhaAtual
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF1CB0F6),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nova Senha
                        TextFormField(
                          //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          //buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                          maxLength: 16,
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerSenhaNova,
                          obscureText: !mostrarSenhaNova,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
                            labelText: "Nova senha:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                            icon: const Icon(
                              Icons.password,
                              color: Color(0xFF1CB0F6),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarSenhaNova = !mostrarSenhaNova;
                                });
                              },
                              child: Icon(
                                mostrarSenhaNova
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF1CB0F6),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Confirmar Senha
                        TextFormField(
                          //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          //buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                          maxLength: 16,
                          cursorColor: Color(0xFF1cB0F6),
                          controller: controllerSenhaConfirmada,
                          obscureText: !mostrarSenhaConfirmada,
                          style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
                            labelText: "Confirmar nova senha:",
                            labelStyle: GoogleFonts.baloo2(
                                color: Color(0xFF878787),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                            icon: const Icon(
                              Icons.password,
                              color: Color(0xFF1CB0F6),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarSenhaConfirmada =
                                  !mostrarSenhaConfirmada;
                                });
                              },
                              child: Icon(
                                mostrarSenhaConfirmada
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF1CB0F6),
                              ),
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
                          _alterarSenha(
                              context,
                              username,
                              controllerSenhaAtual.text.trim(),
                              controllerSenhaNova.text.trim(),
                              controllerSenhaConfirmada.text.trim());
                        }
                      },
                      onTapCancel: () =>
                          setState(() => botaoPressionado = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(0.0, botaoPressionado ? 5.0 : 0.0),
                        decoration: BoxDecoration(
                          color: botaoHabilitado
                              ? const Color(0xFF1CB0F6)
                              : Color(0xFF505050),
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
                              "Alterar Senha",
                              style: GoogleFonts.baloo2(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: botaoHabilitado
                                    ? Colors.white
                                    : Color(0xFF333333),
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
            );
          },
        ),
      );
    },
  );
}

Future<void> _alterarSenha(BuildContext context, String username,
    String senhaAtual, String senhaNova, String senhaConfirmada) async {
  try {
    if (senhaAtual == senhaNova) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Senhas iguais!",
          conteudo:
              "Você colocou a mesma senha tanto no campo de senha atual quanto no campo de senha nova!");
      return;
    }

    if (senhaNova != senhaConfirmada) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Senhas diferentes!",
          conteudo: "Você colocou senhas diferentes nos campos de senha nova!");
      return;
    }

    if (senhaNova.length < 4) {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Senha muito pequena",
          conteudo: "Senha deve ter no mínimo 4 caracteres");
      return;
    }

    String url = obterUrl();
    String link = "$url/api/alterarSenha.php";
    var res = await http.post(Uri.parse(link), body: {
      "username": username,
      "senhanova": senhaNova,
      "senhaatual": senhaAtual
    }).timeout(const Duration(minutes: 1));

    var response = jsonDecode(res.body);
    await exibirResultado(
        context: context,
        tipo: response["sucesso"] == "true"
            ? TipoDialogo.sucesso
            : TipoDialogo.erro,
        titulo: response["sucesso"] == "true"
            ? "Senha alterada com sucesso!"
            : "Algo deu errado!",
        conteudo: response["mensagem"]);

    if (response["sucesso"] == "true") {
      Navigator.pop(context);
    }
  } catch (e) {
    await exibirResultado(
        context: context,
        tipo: TipoDialogo.erro,
        titulo: "Erro ao alterar a senha",
        conteudo: "Tente de novo daqui a pouco!");
  }
}
