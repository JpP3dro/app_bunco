import 'package:flutter/material.dart';
import 'url.dart';

Future<void> dialogoAlterarUrl(BuildContext context, void Function(VoidCallback) atualizarTela) async {
  final TextEditingController controller = TextEditingController(text: await obterUrl());

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Alterar Url'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nova URL',
          hintText: 'Digite a nova URL',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // fecha o pop-up
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            await alterarUrl(controller.text);
            atualizarTela(() {}); // chama setState da tela principal
            Navigator.pop(context); // fecha o pop-up
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}
