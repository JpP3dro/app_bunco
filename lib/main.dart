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
              padding: EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/bunco.png',
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

          //Imagem no canto superior esquerdo
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
    ]
    ),
    );
  }
}