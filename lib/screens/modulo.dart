import 'dart:convert';

import 'package:app_bunco/screens/aula.dart';
import 'package:app_bunco/screens/curso.dart';
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/popup_vidas.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:app_bunco/uteis/url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

class Licao {
  final int id;
  final int idModulo;
  final String titulo;
  final String tipo;
  final int ordem;
  final bool isDone;
  final bool isAvailable;
  final bool rowGray;
  final bool connectorColored;
  final String icon;
  final String subtitulo;

  Licao({
    required this.id,
    required this.idModulo,
    required this.titulo,
    required this.tipo,
    required this.ordem,
    required this.isDone,
    required this.isAvailable,
    required this.rowGray,
    required this.connectorColored,
    required this.icon,
    required this.subtitulo,
  });

  factory Licao.fromJson(Map<String, dynamic> json) {
    return Licao(
      id: json['id'] ?? 0,
      idModulo: json['module_id'] ?? 0,
      titulo: json['title'] ?? json['titulo'] ?? '',
      tipo: json['type'] ?? json['tipo'] ?? '',
      ordem: json['order'] ?? json['ordem'] ?? 0,
      isDone: json['is_done'] == true || json['is_done'] == 1,
      isAvailable: json['is_available'] == true || json['is_available'] == 1,
      rowGray: json['row_gray'] == true || json['row_gray'] == 1,
      connectorColored:
          json['connector_colored'] == true || json['connector_colored'] == 1,
      icon: json['icon'] ?? '',
      subtitulo: json['subtitle'] ?? '',
    );
  }
}

class _TelaModuloState extends State<TelaModulo>
    with AutomaticKeepAliveClientMixin {
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
    Color(0xFF3E7500),
    Color(0xFFB48C0E),
    Color(0xFF5B3399),
    Color(0xFF4C2F1F),
    Color(0xFF820D0D),
    Color(0xFFE64CA7),
    Color(0xFF2B628C),
  ];

  List<Licao> _licoes = [];
  bool _carregando = true;
  String? _erro;

  @override
  bool get wantKeepAlive => true; // ← Isso preserva o estado

  @override
  void initState() {
    super.initState();
    _fetchLicoes();
  }

  Future<void> _fetchLicoes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final urlBase = '${await obterUrl()}/api/buscarModulo.php';
      final modulo = widget.modulo.id;
      final usuario = widget.usuario['id'];
      final uri = Uri.parse('$urlBase?modulo=$modulo&login=$usuario');

      final resposta = await http.get(uri).timeout(Duration(minutes: 2));
      if (resposta.statusCode != 200) {
        throw Exception('Status ${resposta.statusCode}');
      }

      final jsonBody = json.decode(resposta.body);
      final items = jsonBody['licoes'] as List<dynamic>?;
      if (items == null) {
        throw Exception('Resposta inválida: campo lições ausente');
      }

      _licoes = items.map((e) => Licao.fromJson(e)).toList();
      setState(() {
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        //_erro = e.toString();
        _erro = "Algo deu errado, tente novamente mais tarde!";
      });
    }
  }

  Color _moduleAccentColor() {
    final idx =
        (widget.modulo.id - 1).clamp(0, _coresTextoPorModulo.length - 1);
    return _coresTextoPorModulo[idx];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final backgroundColor =
        widget.modoEscuro ? Color(0xFF0D141F) : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
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
        backgroundColor: backgroundColor,
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
              GestureDetector(
                onTap: () {
                  TelaPopupVidas(
                    context: context,
                    modoEscuro: widget.modoEscuro,
                    usuario: widget.usuario,
                  );
                },
                child: Row(
                  children: [
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
                  ],
                ),
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
          Expanded(
            child: _carregando
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFF1CB0F6),
                  ))
                : _erro != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Erro: $_erro',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                                onPressed: _fetchLicoes,
                                child: Text('Tentar novamente'))
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        itemCount: _licoes.length,
                        itemBuilder: (context, index) {
                          final licao = _licoes[index];
                          final nextConnectorColored = licao.connectorColored;
                          final accent = _moduleAccentColor();

                          // estilos dependendo se a linha está cinza
                          final titleStyle = GoogleFonts.baloo2(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: licao.rowGray
                                ? Colors.grey
                                : _coresTituloPorModulo[widget.modulo.id - 1],
                          );
                          final subtitleStyle = GoogleFonts.baloo2(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: licao.rowGray ? Colors.grey : accent,
                          );

                          return InkWell(
                            onTap: () async {
                              if (licao.isAvailable &&
                                  widget.usuario['vidas'] == 0) {
                                await exibirResultado(
                                  context: context,
                                  tipo: TipoDialogo.erro,
                                  titulo: "Sem vidas",
                                  conteudo:
                                      "Você não tem vida para começar uma nova lição!",
                                );
                              } else if (licao.isAvailable) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TelaAula(
                                      usuario: widget.usuario,
                                      idAula: licao.id,
                                      modoEscuro: widget.modoEscuro,
                                      modulo: widget.modulo,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Coluna do ícone + conector vertical
                                  Column(
                                    children: [
                                      // quadrado com ícone
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: licao.rowGray
                                              ? Colors.grey.shade300
                                              : accent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: licao.isAvailable
                                                ? accent
                                                : Colors.grey.shade400,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            size: 45,
                                            licao.icon
                                                    .toLowerCase()
                                                    .contains('book')
                                                ? Icons.menu_book_rounded
                                                : Icons.edit_rounded,
                                            color: licao.rowGray
                                                ? Colors.grey
                                                : _coresFundoPorModulo[
                                                    licao.idModulo - 1],
                                          ),
                                        ),
                                      ),

                                      // conector vertical (somente se não for o último item)
                                      if (index != _licoes.length - 1)
                                        Container(
                                          width: 20,
                                          height: 50,
                                          margin: EdgeInsets.only(top: 0),
                                          decoration: BoxDecoration(
                                            color: nextConnectorColored
                                                ? _coresTituloPorModulo[
                                                    licao.idModulo - 1]
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                    ],
                                  ),

                                  SizedBox(width: 16),

                                  // Conteúdo da lição
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                licao.titulo,
                                                style: titleStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          licao.subtitulo,
                                          style: subtitleStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
