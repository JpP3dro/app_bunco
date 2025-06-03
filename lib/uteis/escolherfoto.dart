import 'package:flutter/material.dart';

/// Este método abre um diálogo “full screen” (ou quase — você pode ajustar tamanho)
/// e, quando o usuário confirmar, retorna o caminho do asset selecionado.
/// Se fechar (X), retorna null.
Future<String?> mostrarSeletorDeFotoDePerfil(BuildContext context, {
  required String fotoAtual,
  required Color corFundo
}) {
  // 1) Defina aqui a lista de caminhos de imagens em assets/profile_pics/
  final List<String> imagePaths = [
    'assets/images/perfil/undefined.png',
    'assets/images/perfil/foto1.png',
    'assets/images/perfil/foto2.png',
    'assets/images/perfil/foto3.png',
  ];

  String selectedImage = imagePaths.contains(fotoAtual) ? fotoAtual : imagePaths.first;

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // evita fechar clicando fora do diálogo
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          // StatefulBuilder permite usar setState _dentro_ do builder do diálogo
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ========== 1) BARRA DE TÍTULO COM “X” ==========
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48), // só pra centralizar o título
                      const Text(
                        'Escolha uma foto',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // Botão “X” para fechar
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(null),
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
                  height: 240,
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

                // ========== 4) BOTÃO DE CONFIRMAR ==========
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Retorna o caminho selecionado para quem chamou o diálogo
                        Navigator.of(context).pop(selectedImage);
                      },
                      child: const Text('Confirmar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
