import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tela Inicial Animada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimatedHomeScreen(), // Usaremos um StatefulWidget para a animação
    );
  }
}

class AnimatedHomeScreen extends StatefulWidget {
  const AnimatedHomeScreen({super.key});

  @override
  _AnimatedHomeScreenState createState() => _AnimatedHomeScreenState();
}

class _AnimatedHomeScreenState extends State<AnimatedHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duração da animação
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // Curva da animação (opcional)
      ),
    );

    // Inicia a animação quando a tela é construída
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mantém a cor de fundo preta
      body: Stack(
        children: [
          // Conteúdo principal centralizado com animação
          Center(
            child: ScaleTransition( // Aplica a animação de escala à Column central
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/bunco.png', // Sua imagem centralizada
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaLogin()),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Começar'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Imagem no canto superior esquerdo (sem animação)
          Positioned(
            top: 30,
            left: 15,
            child: Image.asset(
              'assets/images/mascote1.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto superior direito (sem animação)
          Positioned(
            top: 30,
            right: 15,
            child: Image.asset(
              'assets/images/mascote2.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto inferior esquerdo (sem animação)
          Positioned(
            bottom: 30,
            left: 15,
            child: Image.asset(
              'assets/images/mascote3.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto inferior direito (sem animação)
          Positioned(
            bottom: 30,
            right: 15,
            child: Image.asset(
              'assets/images/mascote4.png',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}