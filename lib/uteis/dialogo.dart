import 'dart:async';

import 'package:flutter/material.dart';
import '../screens/telainicial.dart';
import 'tipo_dialogo.dart';

Future<void> exibirResultado(
    {required BuildContext context,
    required TipoDialogo tipo,
    required String titulo,
    required String conteudo,
    bool temBotao = true,
    bool voltarTelaInicial = false,
    Map<String, dynamic>? usuario,
    bool modoEscuro = true}) async {
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
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        alignment: Alignment.center,
        iconPadding: const EdgeInsets.only(top: 20),
        title: Center(
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600, color: cor, fontSize: 20),
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
        actions: !temBotao
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextButton(
                    onPressed: () {
                      // Se precisa voltar para a tela inicial, faz isso após fechar o diálogo
                      if (voltarTelaInicial) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => TelaInicial(
                                usuario: usuario,
                                parametroModoEscuro: modoEscuro,
                              ),
                            ),
                                (Route<dynamic> route) => true,
                          );
                        });
                      }
                        Navigator.pop(context);

                    },
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
