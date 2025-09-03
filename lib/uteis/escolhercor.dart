import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Color?> mostrarSeletorDeCor(
  BuildContext context, {
  required String fotoAtual,
  required Color corAtual,
}) {
  bool botaoPressionado = false;
  bool botaoHabilitado = false;
  // Cores que o usuário pode escolher
  final List<Color> colorOptions = [
    Color(0xFFA4E451),
    Color(0xFF4BC1FF),
    Color(0xFFFF9F4A),
    Color(0xFFB084F1),
    Color(0xFFFFF275),
    Color(0xFFFF6B6B),
    Color(0xFF7AE7C7),
    Color(0xFF41729F),
    Color(0xFFF2F2F2),
    Color(0xFFFEC89A),
    Color(0xFFA259FF),
    Color(0xFFFFD8A9),
    Color(0xFF88E1F2),
    Color(0xFFF2C94C),
    Color(0xFF202020),
  ];

  Color selectedColor =
      colorOptions.contains(corAtual) ? corAtual : colorOptions.first;

  return showDialog<Color>(
    context: context,
    builder: (buildContext) {
      return Dialog(
        backgroundColor: Color(0xFF333333),
        insetPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: MediaQuery.of(context).size.height * 0.05,
        ),
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      Text(
                        'Escolha a cor de fundo',
                        style: GoogleFonts.baloo2(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
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

                SizedBox(
                  height: 120,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: colorOptions.map((color) {
                        final bool isSelected = color == selectedColor;
                        botaoHabilitado = selectedColor != corAtual;
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
                    onTapDown: (_) => setState(() {
                      if (botaoHabilitado) {
                        botaoPressionado = true;
                      }
                    }),
                    onTapUp: (_) {
                      setState(() {
                        if (botaoHabilitado) {
                          botaoPressionado = false;
                          Navigator.of(context).pop(selectedColor);
                        }
                      });
                    },
                    onTapCancel: () => setState(() => botaoPressionado = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(0.0, botaoPressionado ? 5.0 : 0.0),
                      decoration: BoxDecoration(
                        color: botaoHabilitado
                            ? Color(0xFF1CB0F6)
                            : Color(0xFF505050),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: botaoPressionado || !botaoHabilitado
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
            );
          },
        ),
      );
    },
  );
}
