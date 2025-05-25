import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tela Inicial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimatedHomeScreen(),
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
      duration: const Duration(seconds: 2), // Duração da animação
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
                      'assets/images/bunco.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: const TelaLogin(),
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 1500),
                        )
                      ),
                      icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromWidth(250),
                        backgroundColor: const Color(0xFF4EA5FF),
                      ),
                      label: Text(
                          'Começar',
                        style: GoogleFonts.baloo2(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Imagem no canto superior esquerdo
          Positioned(
            top: 30,
            left: 15,
            child: Image.asset(
              'assets/images/mascote1.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto superior direito
          Positioned(
            top: 30,
            right: 15,
            child: Image.asset(
              'assets/images/mascote2.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto inferior esquerdo
          Positioned(
            bottom: 30,
            left: 15,
            child: Image.asset(
              'assets/images/mascote3.png',
              width: 100,
              height: 100,
            ),
          ),

          // Imagem no canto inferior direito
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