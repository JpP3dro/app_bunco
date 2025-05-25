import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_bunco/screens/alterarnome.dart';
import 'package:app_bunco/screens/alterarusername.dart';
import 'package:app_bunco/screens/alteraremail.dart';
import 'package:app_bunco/screens/alterarsenha.dart';
import 'package:app_bunco/screens/alterarlinks.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
  }
  
  class _TelaConfiguracoesState extends State<TelaConfiguracoes> {

    final List<Map<String, dynamic>> opcoes = [
      {"label": "Alterar o nome", "page": TelaAlterarNome()},
      {"label": "Alterar o username", "page": TelaAlterarUsername()},
      {"label": "Alterar o email", "page": TelaAlterarEmail()},
      {"label": "Alterar a senha", "page": TelaAlterarSenha()},
      {"label": "Adicionar links para as redes sociais", "page": TelaAlterarLinks()},
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "Configurações",
          style: GoogleFonts.baloo2(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: opcoes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => opcoes[index]['page']),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.vertical(
                        top: index == 0 ? Radius.circular(20) : Radius.circular(0),
                        bottom: index == 4 ? Radius.circular(20) : Radius.circular(0),
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opcoes[index]['label'],
                        style: GoogleFonts.baloo2(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                    label: Text(
                        "Sair da conta",
                      style: GoogleFonts.baloo2(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                        "Excluir a conta",
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  }