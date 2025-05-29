import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaPerfil extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const TelaPerfil({
    super.key,
    required this.usuario,
  });


  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Perfil",
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Foto circular + dois botões nas laterais (vermelhos)
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Círculo da foto
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/perfil/undefined.jpg'),
                    ),
                    // Botão à esquerda
                    Positioned(
                      left: -10,
                      bottom: -25,
                      child: IconButton(
                        onPressed: () { /* ação */ },
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 24,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    // Botão à direita
                    Positioned(
                      right: -10,
                      bottom: -25,
                      child: IconButton(
                        onPressed: () { /* ação */ },
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                        iconSize: 24,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // 2) Texto ao lado da foto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.usuario["nome"],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('@${widget.usuario["username"]}', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Divider(
              color: Colors.black,
            ),

            // 3) Botões sociais (círculos azuis)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage("assets/images/icone/icone-github.png"),
                    height: 40,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage("assets/images/icone/icone-instagram.png"),
                    height: 40,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage("assets/images/icone/icone-linkedin.png"),
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 4) Três cards verdes, cada um com imagem e texto
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: List.generate(3, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Imagem no topo
                        Image.asset(
                          'assets/images/item_$index.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        // Texto embaixo
                        Text(
                          'Item ${index + 1}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}