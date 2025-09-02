import 'package:app_bunco/screens/curso.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaModulo extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final bool modoEscuro;
  final Modulo modulo;
  const TelaModulo(
      {super.key,
      required this.usuario,
      required this.modoEscuro,
      required this.modulo});

  @override
  State<TelaModulo> createState() => _TelaModuloState();
}

class _TelaModuloState extends State<TelaModulo> {
  final List<Color> _coresTextoPorModulo = [
    Color(0xFF15D2D6),
    Color(0xFF84C1FF),
    Color(0xFF3E7500),
    Color(0xFFE8B84D),
    Color(0xFF6F4EA1),
    Color(0xFF7B4A13),
    Color(0xFF820D0D),
    Color(0xFFF778C3),
    Color(0xFF2B628C),
  ];

  final List<Color> _coresFundoPorModulo = [
    Color(0xFFBBF2FF),
    Color(0xFFE0F9FF),
    Color(0xFFA5ED6E),
    Color(0xFFF8E4AF),
    Color(0xFFCE82FF),
    Color(0xFFE5A259),
    Color(0xFFFF4B4B),
    Color(0xFFFFBDE5),
    Color(0xFF7ABCFF),
  ];

  final List<Color> _coresTituloPorModulo = [
    Color(0xFF0E898B),
    Color(0xFF0888C4),
    Color(0xFF003E1C),
    Color(0xFFB48C0E),
    Color(0xFF5B3399),
    Color(0xFF4C2F1F),
    Color(0xFF420000),
    Color(0xFFE64CA7),
    Color(0xFF2B628C),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1CB0F6),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 60,
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.usuario['modulos'].toString(),
                style: GoogleFonts.baloo2(
                  color: Color(0xFFF89700),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                "assets/images/icone/icone-modulo.png",
                width: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                widget.usuario['vidas'].toString(),
                style: GoogleFonts.baloo2(
                  color: Color(0xFFEA2B2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                "assets/images/icone/icone-vida.png",
                width: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                widget.usuario['ofensiva'].toString(),
                style: GoogleFonts.baloo2(
                  color: Color(0xFFFFC800),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                "assets/images/icone/icone-ofensiva.png",
                width: 25,
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // altura da linha
          child: Container(
            color: Color(0xFF2C2F35),
            height: 4.0, // espessura da linha
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: _coresFundoPorModulo[widget.modulo.id - 1],
            height: 130,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/modulos/modulo${widget.modulo.id}progresso.png',
                  width: 80,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.modulo.titulo.toString(),
                        style: GoogleFonts.baloo2(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _coresTituloPorModulo[widget.modulo.id - 1]),
                      ),
                      Text(
                        widget.modulo.descricao.toString(),
                        style: GoogleFonts.baloo2(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _coresTextoPorModulo[widget.modulo.id - 1]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Colocar as aulas aqui
        ],
      ),
    );
  }
}
