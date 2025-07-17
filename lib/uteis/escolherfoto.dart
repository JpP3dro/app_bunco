import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Este método abre um diálogo “full screen” (ou quase — você pode ajustar tamanho)
/// e, quando o usuário confirmar, retorna o caminho do asset selecionado.
/// Se fechar (X), retorna null.
Future<String?> mostrarSeletorDeFotoDePerfil(BuildContext context, {
  required String fotoAtual,
  required Color corFundo
}) {
  bool botaoPressionado = false;
  // 1) Defina aqui a lista de caminhos de imagens em assets/profile_pics/
  final List<String> imagePaths = [
    'assets/images/perfil/buncodefault.png',
    'assets/images/perfil/buncoandroid.png',
    'assets/images/perfil/buncoapple.png',
    'assets/images/perfil/buncocavalheiro.png',
    'assets/images/perfil/buncodetetive.png',
    'assets/images/perfil/buncoduolingo.png',
    'assets/images/perfil/buncofazendeiro.png',
    'assets/images/perfil/buncoformando.png',
    'assets/images/perfil/buncolegal.png',
    'assets/images/perfil/buncomimo.png',
    'assets/images/perfil/buncoromantico.png',
  ];

  String selectedImage = imagePaths.contains(fotoAtual) ? fotoAtual : imagePaths.first;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Color(0xFF333333),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          // StatefulBuilder permite usar setState _dentro_ do builder do diálogo
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
                      const SizedBox(width: 20),
                      Text(
                        'Escolha a foto de perfil',
                        style: GoogleFonts.baloo2(
                            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
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
                // Vamos travar a altura do Grid para não estourar a tela
                SizedBox(
                  height: 340,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,       // 3 colunas
                      crossAxisSpacing: 8,     // espaçamento horizontal entre itens
                      mainAxisSpacing: 8,      // espaçamento vertical entre itens
                    ),
                    itemCount: imagePaths.length,
                    itemBuilder: (_, index) {
                      final path = imagePaths[index];
                      final bool isSelected = path == selectedImage;

                      return GestureDetector(
                        onTap: () {
                          // ao clicar, atualiza a imagem selecionada e muda o preview
                          setState(() {
                            selectedImage = path;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Container com borda para indicar seleção
                            Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey.shade300,
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
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blueAccent,
                                size: 28,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ======== 4) BOTÃO DE CONFIRMAR ========
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTapDown: (_) =>
                        setState(() => botaoPressionado = true),
                    onTapUp: (_) {
                      setState(() => botaoPressionado = false);
                      Navigator.of(context).pop(selectedImage);
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
                            "Alterar a foto",
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
