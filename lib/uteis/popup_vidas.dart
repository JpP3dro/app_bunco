import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int parseVidas(dynamic valor) {
  if (valor == null) return 0;
  if (valor is int) return valor;
  return int.tryParse(valor.toString()) ?? 0;
}

String tempoRecuperacao() {
  // Define o timezone de Brasília
  final agora = DateTime.now().toUtc().add(const Duration(hours: -3)); // UTC-3

  // Lista dos horários de recuperação no dia atual
  final List<DateTime> horarios = [
    DateTime(agora.year, agora.month, agora.day, 0),
    DateTime(agora.year, agora.month, agora.day, 8),
    DateTime(agora.year, agora.month, agora.day, 16),
  ];

  // Procura o próximo horário de regeneração
  DateTime? proximo;
  for (var h in horarios) {
    if (h.isAfter(agora)) {
      proximo = h;
      break;
    }
  }

  // Se já passou de 16h, o próximo é meia-noite do dia seguinte
  proximo ??= DateTime(agora.year, agora.month, agora.day + 1, 0);

  // Calcula a diferença
  final diff = proximo.difference(agora);
  final horas = diff.inHours;
  final minutos = diff.inMinutes.remainder(60);

  return '${horas}h ${minutos}m';
}

Future<void> TelaPopupVidas({
  required BuildContext context,
  required bool modoEscuro,
  required Map<String, dynamic> usuario,
}) {
  final int vidas = parseVidas(usuario['vidas']);
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: modoEscuro ? Color(0xFF0D141F) : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Stack(
                children: [
                  // Ícone de voltar alinhado à esquerda
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color:
                            modoEscuro ? Color(0xFF1CB0F6) : Color(0xFFAFAFAF),
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  // Imagens centralizadas
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          vidas > 0
                              ? "assets/images/icone/icone-vida.png"
                              : modoEscuro
                                  ? "assets/images/icone/icone-vida-vazia-escuro.png"
                                  : "assets/images/icone/icone-vida-vazia-claro.png",
                          width: 30,
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          vidas > 1
                              ? "assets/images/icone/icone-vida.png"
                              : modoEscuro
                                  ? "assets/images/icone/icone-vida-vazia-escuro.png"
                                  : "assets/images/icone/icone-vida-vazia-claro.png",
                          width: 30,
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          vidas > 2
                              ? "assets/images/icone/icone-vida.png"
                              : modoEscuro
                                  ? "assets/images/icone/icone-vida-vazia-escuro.png"
                                  : "assets/images/icone/icone-vida-vazia-claro.png",
                          width: 30,
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          vidas > 3
                              ? "assets/images/icone/icone-vida.png"
                              : modoEscuro
                                  ? "assets/images/icone/icone-vida-vazia-escuro.png"
                                  : "assets/images/icone/icone-vida-vazia-claro.png",
                          width: 30,
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          vidas > 4
                              ? "assets/images/icone/icone-vida.png"
                              : modoEscuro
                                  ? "assets/images/icone/icone-vida-vazia-escuro.png"
                                  : "assets/images/icone/icone-vida-vazia-claro.png",
                          width: 30,
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vidas < 5
                        ? "Próxima vida em "
                        : "Você está com todas as vidas!",
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: modoEscuro ? Colors.white : Color(0xFF4B4B4B),
                    ),
                  ),
                  Text(
                    vidas < 5 ? tempoRecuperacao() : "",
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEA2B2B),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/popup/${usuario["vidas"]}-${modoEscuro ? "escuro" : "claro"}.png",
                height: 150,
              ),
            ],
          ),
        ),
      );
    },
  );
}
