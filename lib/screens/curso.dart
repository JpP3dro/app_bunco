import 'dart:convert';
import 'package:app_bunco/screens/modulo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../uteis/url.dart';

class TelaCurso extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final bool modoEscuro;
  const TelaCurso({super.key, required this.usuario, required this.modoEscuro});

  @override
  State<TelaCurso> createState() => _TelaCursoState();
}

class _TelaCursoState extends State<TelaCurso> {
  bool _carregando = true;
  String? _erro;
  List<Modulo> _modulos = [];

  final Color _corBloqueado = const Color(0xAA4B4B4B);
  final Color _corCompleto = const Color(0xFFF89700);

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
  void initState() {
    super.initState();
    _carregarModulos();
  }

  Future<void> _carregarModulos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('idUsuario');
      if (id == null || id.isEmpty) {
        setState(() {
          _erro = "Usuário não autenticado";
          _carregando = false;
        });
        return;
      }

      final url = await obterUrl();
      final link = Uri.parse("$url/api/buscarCurso.php");

      final res = await http.post(link, body: {
        "login": id,
      }).timeout(const Duration(seconds: 20));

      if (res.statusCode != 200) {
        setState(() {
          //_erro = "Erro HTTP: ${res.statusCode}";
          _erro = "Erro ao fazer a comunicação com o servidor!";
          _carregando = false;
        });
        return;
      }

      final map = jsonDecode(res.body);
      if (map == null || map['sucesso'] != "true") {
        setState(() {
          _erro = map != null && map['mensagem'] != null
              ? map['mensagem'].toString()
              : "Resposta inválida da API";
          _carregando = false;
        });
        return;
      }

      final List raw = map['modulos'] ?? [];
      _modulos =
          raw.map((e) => Modulo.fromMap(Map<String, dynamic>.from(e))).toList();

      setState(() {
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        //_erro = "Erro ao carregar módulos: $e";
        _erro = "Erro ao carregar módulos!";
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
      appBar: AppBar(
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregarModulos,
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _erro != null
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(
                            child: Text(_erro!,
                                style: TextStyle(color: Colors.red))),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _carregarModulos,
                            child: const Text("Tentar novamente"),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _modulos.length,
                      itemBuilder: (context, index) {
                        final modulo = _modulos[index];
                        final status = modulo.status ?? "";

                        Color corBorda;
                        Color corTexto;
                        Color corTitulo;
                        Widget imagemModulo;

                        if (status == "bloqueado") {
                          corBorda = _corBloqueado;
                          corTexto = _corBloqueado;
                          corTitulo = _corBloqueado;
                        } else if (status == "completo") {
                          corBorda = _corCompleto;
                          corTexto = _corCompleto;
                          corTitulo = _corCompleto;
                        } else {
                          final cor = _coresTextoPorModulo[
                              index % _coresTextoPorModulo.length];
                          final cor2 = _coresTituloPorModulo[
                              index % _coresTituloPorModulo.length];
                          corBorda = cor;
                          corTexto = cor;
                          corTitulo = cor2;
                        }
                        imagemModulo = Image.asset(
                          "assets/images/modulos/modulo${(modulo.id).toString()}$status.png",
                          width: 80,
                          height: status == "completo" ? 100 : 80,
                        );

                        return GestureDetector(
                          onTap: status == "bloqueado"
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TelaModulo(
                                        modoEscuro: widget.modoEscuro,
                                        usuario: widget.usuario,
                                        modulo: _modulos[index],
                                      ),
                                    ),
                                  );
                                },
                          child: Container(
                            height: 190,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: corBorda, width: 4),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: status == "bloqueado"
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => TelaModulo(
                                                  modoEscuro: widget.modoEscuro,
                                                  usuario: widget.usuario,
                                                  modulo: _modulos[index]),
                                            ),
                                          );
                                        },
                                  child: imagemModulo,
                                ),
                                const SizedBox(width: 14),
                                // texto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        modulo.titulo ?? "Sem título",
                                        style: GoogleFonts.baloo2(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: corTitulo,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            modulo.descricao ?? "",
                                            style: GoogleFonts.baloo2(
                                              fontSize: 13,
                                              color: corTexto,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${modulo.licoesFeitas}/${modulo.totalLicoes}",
                                  style: GoogleFonts.baloo2(
                                      fontSize: 12,
                                      color: corTexto,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

/// Modelo simples do módulo
class Modulo {
  final int id;
  final String? titulo;
  final String? descricao;
  final int totalLicoes;
  final int licoesFeitas;
  final String? status;

  Modulo({
    required this.id,
    this.titulo,
    this.descricao,
    required this.totalLicoes,
    required this.licoesFeitas,
    this.status,
  });

  factory Modulo.fromMap(Map<String, dynamic> m) {
    return Modulo(
      id: (m['id'] is int) ? m['id'] : int.tryParse(m['id'].toString()) ?? 0,
      titulo: m['titulo']?.toString(),
      descricao: m['descricao']?.toString(),
      totalLicoes: (m['total_licoes'] is int)
          ? m['total_licoes']
          : int.tryParse(m['total_licoes']?.toString() ?? '0') ?? 0,
      licoesFeitas: (m['licoes_feitas'] is int)
          ? m['licoes_feitas']
          : int.tryParse(m['licoes_feitas']?.toString() ?? '0') ?? 0,
      status: m['status']?.toString(),
    );
  }
}
