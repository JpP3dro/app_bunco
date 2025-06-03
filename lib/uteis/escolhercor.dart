import 'package:flutter/material.dart';

/// Abre um diálogo para o usuário escolher uma cor de fundo para o CircleAvatar.
/// - [context]: BuildContext do widget chamador.
/// - [imagePath]: caminho do asset da imagem já escolhida (ou você pode adaptar para NetworkImage/FileImage).
/// - [corAtual]: a cor que estava selecionada até o momento (para iniciar o diálogo já com ela marcada).
///
/// Retorna a [Color] escolhida pelo usuário, ou `null` se ele fechar o diálogo sem confirmar.
Future<Color?> mostrarSeletorDeCor(
    BuildContext context, {
      required String fotoAtual,
      required Color corAtual,
    }) {
  // 1) Defina aqui a paleta de cores que o usuário poderá escolher:
  final List<Color> colorOptions = [
    Color(0xFFF44336),
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.grey,
    Colors.black,
  ];

  // 2) Começamos com a cor atual, se ela estiver na paleta; senão, usamos a primeira da lista
  Color selectedColor =
  colorOptions.contains(corAtual) ? corAtual : colorOptions.first;

  return showDialog<Color>(
    context: context,
    barrierDismissible: false, // pra forçar a escolha ou o “X”
    builder: (buildContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ======== 1) BARRA DE TÍTULO COM “X” ========
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      const Text(
                        'Escolha a cor de fundo',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(null),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ======== 2) PREVIEW DO CircleAvatar ========
                CircleAvatar(
                  radius: 50,
                  backgroundColor: selectedColor,
                  backgroundImage: AssetImage(fotoAtual),
                ),

                const SizedBox(height: 16),

                // ======== 3) PALETA DE CORES DISPONÍVEIS ========
                // Vamos colocar num SizedBox para limitar altura e permitir scroll, se necessário
                SizedBox(
                  height: 120,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: colorOptions.map((color) {
                        final bool isSelected = color == selectedColor;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 3 : 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ======== 4) BOTÃO DE CONFIRMAR ========
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectedColor);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Confirmar'),
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
