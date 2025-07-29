import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool botaoPressionado = false;
  // 1) Defina aqui a paleta de cores que o usuário poderá escolher:
  final List<Color> colorOptions = [
    Color(0xFF586892),
    Color(0xFF0E898B),
    Color(0xFF7AF0F2),
    Color(0xFFFF9600),
    Color(0xFFFFC800),
    Color(0xFFE5A259),
    Color(0xFFEA2B2B),
    Color(0xFF9069CD),
    Color(0xFFFFAADE),
    Color(0xFF5EB200),
    Color(0xFFA5ED6E),
    Color(0xFF8E8E93),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
  ];

  // 2) Começamos com a cor atual, se ela estiver na paleta; senão, usamos a primeira da lista
  Color selectedColor =
  colorOptions.contains(corAtual) ? corAtual : colorOptions.first;

  return showDialog<Color>(
    context: context,
    builder: (buildContext) {
      return Dialog(
        backgroundColor: Color(0xFF333333),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ======== 1) BARRA DE TÍTULO ========
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF4D4D4D),
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFFF4B4B),
                        radius: 7,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xFFFFB100),
                        radius: 7,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xFF58CC02),
                        radius: 7,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Escolha a cor de fundo',
                        style: GoogleFonts.baloo2(
                            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
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

                // Vamos colocar num SizedBox para limitar altura e permitir scroll, se necessário
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
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

                // ======== 4) BOTÃO DE CONFIRMAR ========
                Container(
                  margin: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTapDown: (_) =>
                        setState(() => botaoPressionado = true),
                    onTapUp: (_) {
                      setState(() => botaoPressionado = false);
                      Navigator.of(context).pop(selectedColor);
                    },
                    onTapCancel: () =>
                        setState(() => botaoPressionado = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(0.0, botaoPressionado ? 5.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1CB0F6),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: botaoPressionado
                            ? null
                            : [
                          BoxShadow(
                            color: Color(0xFF1453A3),
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
                            "Alterar a cor",
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white,
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
