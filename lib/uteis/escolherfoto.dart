import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> mostrarSeletorDeFotoDePerfil(BuildContext context,
    {required String fotoAtual, required Color corFundo}) {
  bool botaoPressionado = false;
  bool botaoHabilitado = false;
  // 1) Defina aqui a lista de caminhos de imagens em assets/images/perfil/
  final List<String> imagePaths = [
    'assets/images/perfil/buncodefault.png',
    'assets/images/perfil/buncolegal.png',
    'assets/images/perfil/buncoandroid.png',
    'assets/images/perfil/buncoapple.png',
    'assets/images/perfil/buncoduolingo.png',
    'assets/images/perfil/buncomimo.png',
    'assets/images/perfil/buncograsshopper.png',
    'assets/images/perfil/buncobobo.png',
    'assets/images/perfil/buncodesanimado.png',
    'assets/images/perfil/buncodesapontado.png',
    'assets/images/perfil/buncodesconfiado.png',
    'assets/images/perfil/bunconerd.png',
    'assets/images/perfil/buncomorto.png',
    'assets/images/perfil/buncoformando.png',
    'assets/images/perfil/buncodetetive.png',
    'assets/images/perfil/buncojardineiro.png',
    'assets/images/perfil/buncoromantico.png',
    'assets/images/perfil/buncoalien.png',
    'assets/images/perfil/buncomexicano.png',
    'assets/images/perfil/buncoprofessor.png',

  ];

  String selectedImage =
      imagePaths.contains(fotoAtual) ? fotoAtual : imagePaths.first;

  return showDialog<String>(
    context: context,
    builder: (context) {
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
                // ========== 1) BARRA DE TÍTULO ==========
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
                        'Escolha a foto de perfil',
                        style: GoogleFonts.baloo2(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ========== 2) PREVIEW DO CircleAvatar ==========
                CircleAvatar(
                  radius: 50,
                  backgroundColor: corFundo,
                  backgroundImage: AssetImage(selectedImage),
                ),

                const SizedBox(height: 16),

                // ========== 3) GRID COM AS IMAGENS DISPONÍVEIS ==========
                SizedBox(
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(imagePaths.length, (index) {
                        final path = imagePaths[index];
                        final isSelected = path == selectedImage;
                        botaoHabilitado = selectedImage != fotoAtual;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage = path;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ======== 4) BOTÃO DE CONFIRMAR ========
                Container(
                  margin: const EdgeInsets.all(10),
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
                          Navigator.of(context).pop(selectedImage);
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
                            "Alterar a foto",
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
