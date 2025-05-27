import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/images/telainicial/bunco.svg',
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
                          duration: const Duration(milliseconds: 1000),
                        ),
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

          // Seções das imagens posicionadas
          Positioned(
            top: 30,
            left: 15,
            child: SvgPicture.asset(
              'assets/images/telainicial/mascote1.svg',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 30,
            right: 15,
            child: Image.asset(
              'assets/images/telainicial/mascote2.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: Image.asset(
              'assets/images/telainicial/mascote3.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 30,
            right: 15,
            child: SvgPicture.asset(
              'assets/images/telainicial/mascote4.svg',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}