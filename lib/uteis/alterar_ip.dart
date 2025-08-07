import 'package:flutter/material.dart';
import 'ip.dart';

void dialogoAlterarIP(BuildContext context, void Function(VoidCallback) atualizarTela) {
  final TextEditingController controller = TextEditingController(text: obterIP());

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Alterar IP'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Novo IP',
          hintText: 'Digite o novo IP',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // fecha o pop-up
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            alterarIP(controller.text);
            atualizarTela(() {}); // chama setState da tela principal
            Navigator.pop(context); // fecha o pop-up
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}
