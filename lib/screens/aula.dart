import 'package:app_bunco/screens/telainicial.dart';
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:app_bunco/uteis/url.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'curso.dart';

class TelaAula extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final int idAula;
  final bool modoEscuro;
  final Modulo modulo;

  const TelaAula(
      {super.key,
      required this.usuario,
      required this.idAula,
      required this.modoEscuro,
      required this.modulo});

  @override
  State<TelaAula> createState() => _TelaAulaState();
}

class _TelaAulaState extends State<TelaAula>
    with AutomaticKeepAliveClientMixin {
  bool _concluindoAula = false;
  late Cloudinary cloudinary;
  List<List<String>?> _ordenacaoItens = [];
  late Future<AulaDetalhada> _futureAula;
  int _currentPage = 0;
  late PageController _pageController;
  AulaDetalhada? _aulaData;
  List<bool> _exerciciosConcluidos =
      []; // Controla se cada exercício foi concluído
  List<dynamic> _respostas = []; // Armazena as respostas dos usuários

  @override
  bool get wantKeepAlive => true; // ← Isso preserva o estado

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryObject.fromCloudName(cloudName: 'dmcahqhac');
    _futureAula = _fetchAulaDetalhada();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<AulaDetalhada> _fetchAulaDetalhada() async {
    final response = await http.post(
      Uri.parse('${await obterUrl()}/api/buscarAula.php'),
      body: {
        'aula_id': widget.idAula.toString(),
        'usuario_id': widget.usuario['id'].toString(),
      },
    ).timeout(Duration(minutes: 1));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['sucesso']) {
        setState(() {
          _aulaData = AulaDetalhada.fromJson(data['dados']);
          // Inicializa a lista de exercícios concluídos
          _exerciciosConcluidos = List.generate(
            _aulaData!.conteudo.length,
            (index) =>
                _aulaData!.conteudo[index].tipo == 'texto' ||
                _aulaData!.conteudo[index].tipo == 'exemplo' ||
                _aulaData!.conteudo[index].tipo == 'desafio',
          );
          // Inicializa a lista de respostas
          _respostas =
              List.generate(_aulaData!.conteudo.length, (index) => null);

          // Inicializa o estado de ordenação: copia os itens originais para cada exercício do tipo 'ordenacao'
          _ordenacaoItens = List.generate(_aulaData!.conteudo.length, (index) {
            final c = _aulaData!.conteudo[index];
            if (c.tipo == 'ordenacao' && c.itens != null) {
              return List<String>.from(
                  c.itens!); // lista mutável que o usuário irá reordenar
            }
            return null;
          });
        });
        return _aulaData!;
      } else {
        await exibirResultado(
            context: context,
            tipo: TipoDialogo.erro,
            titulo: "Erro ao carregar aula",
            conteudo: data['mensagem']);
        throw Exception('Falha ao carregar aula');
      }
    } else {
      await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro de conexão",
          conteudo: "Erro ao se conectar com o servidor");
      throw Exception('Falha ao carregar aula');
    }
  }

  void _proximaTela() {
    // Verifica se o exercício atual foi concluído (se for um exercício)
    final currentContent = _aulaData!.conteudo[_currentPage];
    final isExercise = currentContent.tipo == 'multipla_escolha' ||
        currentContent.tipo == 'verdadeiro_falso' ||
        currentContent.tipo == 'complete' ||
        currentContent.tipo == 'ordenacao';

    if (isExercise && !_exerciciosConcluidos[_currentPage]) {
      // Mostra mensagem se o exercício não foi concluído
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Complete o exercício antes de avançar.'),
            duration: Duration(seconds: 1)),
      );
      return;
    }

    if (_aulaData != null && _currentPage < _aulaData!.conteudo.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _voltarTela() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Função para marcar um exercício como concluído
  void _marcarExercicioConcluido(int index, dynamic resposta) {
    setState(() {
      _exerciciosConcluidos[index] = true;
      _respostas[index] = resposta;
    });
  }

  Future<void> _concluirAula() async {
    if (_concluindoAula) return;

    setState(() {
      _concluindoAula = true;
    });
    try {
      final response = await http.post(
        Uri.parse('${await obterUrl()}/api/concluirAula.php'),
        body: {
          'aula_id': widget.idAula.toString(),
          'usuario_id': widget.usuario['id'].toString(),
        },
      ).timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['sucesso']) {
          setState(() {
            widget.usuario['xp'] += int.parse(data['xp_ganho']);
            widget.usuario['ofensiva'] = data['ofensiva'];
            if (data['modulo_ganho']) {
              widget.usuario['modulos'] += 1;
            }
          });
          await exibirResultado(
              context: context,
              tipo: TipoDialogo.sucesso,
              titulo: "Aula concluida!",
              conteudo: data['mensagem'],
              voltarTelaInicial: true,
              usuario: widget.usuario,
              modoEscuro: widget.modoEscuro);
        } else {
          await exibirResultado(
            context: context,
            tipo: TipoDialogo.erro,
            titulo: "Algo deu errado!",
            conteudo: data['mensagem'],
          );
        }
      } else {
        await exibirResultado(
          context: context,
          tipo: TipoDialogo.alerta,
          titulo: "Requisição deu errado!",
          conteudo: "Algo deu errado ao fazer a requisição!",
        );
      }
    } catch (e) {
      await exibirResultado(
        context: context,
        tipo: TipoDialogo.alerta,
        titulo: "Erro ao concluir a aula",
        //conteudo: e.toString(),
        conteudo: "Algo deu errado. Tente novamente mais tarde!",
      );
    }
  }

  Future<bool> _perderVida() async {
    try {
      final response = await http.post(
        Uri.parse('${await obterUrl()}/api/perderVida.php'),
        body: {
          'usuario_id': widget.usuario['id'].toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['sucesso']) {
          final vidasRestantes = data['vidas_restantes'];
          setState(() {
            widget.usuario['vidas'] = vidasRestantes;
          });
          if (vidasRestantes == 0) {
            await exibirResultado(
                context: context,
                tipo: TipoDialogo.erro,
                titulo: "Sem vidas!",
                conteudo: "Você perdeu todas as suas vidas!",
                voltarTelaInicial: true,
                modoEscuro: widget.modoEscuro,
                usuario: widget.usuario
            );
          }
          return true;
        } else {
          // Se a requisição não foi bem-sucedida, verifica se a mensagem indica que não tem vidas
          // Ou se as vidas atuais já são 0, então exibe a mensagem
          if (widget.usuario['vidas'] == 0) {
            await exibirResultado(
                context: context,
                tipo: TipoDialogo.erro,
                titulo: "Sem vidas!",
                conteudo: "Você perdeu todas as suas vidas!",
                voltarTelaInicial: true,
                modoEscuro: widget.modoEscuro,
                usuario: widget.usuario
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['mensagem']),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de conexão com o servidor'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TelaInicial(
                usuario: widget.usuario,
                parametroModoEscuro:
                MediaQuery.of(context).platformBrightness ==
                    Brightness.dark,
              )),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1CB0F6),
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TelaInicial(
                      usuario: widget.usuario,
                      parametroModoEscuro:
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark,
                    )),
              );
            },
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 60,
          title: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.usuario['vidas'].toString(),
                  style: GoogleFonts.baloo2(
                    color: Color(0xFFEA2B2B),
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/icone/icone-vida.png",
                  width: 30,
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Color(0xFF2C2F35),
              height: 4.0,
            ),
          ),
        ),
        body: FutureBuilder<AulaDetalhada>(
          future: _futureAula,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1CB0F6),
                  ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro: ${snapshot.error}',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else if (snapshot.hasData) {
              final aula = snapshot.data!;
              return _buildAulaContent(aula);
            } else {
              return Center(
                child: Text('Nenhum dado disponível'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAulaContent(AulaDetalhada aula) {
    return Column(
      children: [
        // Barra de progresso
        LinearProgressIndicator(
          value: (_currentPage + 1) / aula.conteudo.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1CB0F6)),
        ),

        // Conteúdo da aula
        Expanded(
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: aula.conteudo.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildTelaConteudo(aula.conteudo[index], index);
            },
          ),
        ),

        // Navegação
        _buildNavigation(aula),
      ],
    );
  }

  Widget _buildTelaConteudo(ConteudoAula conteudo, int index) {
    switch (conteudo.tipo) {
      case 'texto':
        return _buildTelaTexto(conteudo);
      case 'exemplo':
        return _buildTelaExemplo(conteudo);
      case 'multipla_escolha':
        return _buildTelaMultiplaEscolha(conteudo, index);
      case 'verdadeiro_falso':
        return _buildTelaVerdadeiroFalso(conteudo, index);
      case 'complete':
        return _buildTelaComplete(conteudo, index);
      case 'ordenacao':
        return _buildTelaOrdenacao(conteudo, index);
      case 'desafio':
        return _buildTelaDesafio(conteudo);
      default:
        return Center(child: Text('Tipo de conteúdo não suportado'));
    }
  }

  Widget _buildTelaTexto(ConteudoAula conteudo) {
    int telaAtual = _currentPage + 1;
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            conteudo.conteudo ?? '',
            style: TextStyle(fontSize: 18, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: CldImageWidget(
              publicId: 'image-${widget.idAula}-$telaAtual',
              cloudinary: cloudinary,
              //height: 300,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1CB0F6),
                ),
              ),

              errorBuilder: (context, url, error) => Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelaExemplo(ConteudoAula conteudo) {
    int telaAtual = _currentPage + 1;
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conteudo.titulo != null)
            Text(
              conteudo.titulo!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 16),
          if (conteudo.passos != null)
            ...conteudo.passos!.map((passo) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('• $passo', style: TextStyle(fontSize: 16)),
                )),
          Center(
            child: CldImageWidget(
              publicId: 'image-${widget.idAula}-$telaAtual',
              cloudinary: cloudinary,
              //height: 300,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1CB0F6),
                ),
              ),

              errorBuilder: (context, url, error) => Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelaMultiplaEscolha(ConteudoAula conteudo, int index) {
    // Verifica se respostaCorreta é um inteiro
    int? respostaCerta;
    if (conteudo.respostaCorreta is int) {
      respostaCerta = conteudo.respostaCorreta;
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conteudo.pergunta ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          if (conteudo.opcoes != null)
            ...conteudo.opcoes!.asMap().entries.map((entry) {
              final opcaoIndex = entry.key;
              final opcao = entry.value;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: _exerciciosConcluidos[index]
                      ? null // Desativa o botão se já foi respondido
                      : () {
                          // Lógica para verificar resposta
                          if (respostaCerta != null &&
                              opcaoIndex == respostaCerta) {
                            // Resposta correta
                            _marcarExercicioConcluido(index, opcaoIndex);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Resposta correta!'),
                                  duration: Duration(seconds: 1)),
                            );
                          } else {
                            // Resposta incorreta
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Resposta incorreta!'),
                                  duration: Duration(seconds: 1)),
                            );
                            _perderVida();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: _exerciciosConcluidos[index] &&
                            _respostas[index] == opcaoIndex
                        ? (opcaoIndex == respostaCerta
                            ? Colors.green
                            : Colors.red)
                        : null,
                  ),
                  child: Text(
                    opcao,
                    style: TextStyle(
                      color: _exerciciosConcluidos[index] &&
                              _respostas[index] == opcaoIndex
                          ? Colors.white
                          : null,
                    ),
                  ),
                ),
              );
            }),
          if (_exerciciosConcluidos[index])
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Exercício concluído!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelaVerdadeiroFalso(ConteudoAula conteudo, int index) {
    // Verifica se respostaCorreta é um booleano
    bool? respostaCerta;
    if (conteudo.respostaCorreta is bool) {
      respostaCerta = conteudo.respostaCorreta;
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conteudo.pergunta ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _exerciciosConcluidos[index]
                    ? null // Desativa o botão se já foi respondido
                    : () {
                        // Lógica para verificar resposta verdadeiro
                        if (respostaCerta != null && respostaCerta == true) {
                          _marcarExercicioConcluido(index, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Resposta correta!'),
                                duration: Duration(seconds: 1)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Resposta incorreta!'),
                                duration: Duration(seconds: 1)),
                          );
                          _perderVida();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  backgroundColor:
                      _exerciciosConcluidos[index] && _respostas[index] == true
                          ? (respostaCerta == true ? Colors.green : Colors.red)
                          : Colors.green,
                ),
                child: Text(
                  'Verdadeiro',
                  style: TextStyle(
                    fontSize: 16,
                    color: _exerciciosConcluidos[index] &&
                            _respostas[index] == true
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _exerciciosConcluidos[index]
                    ? null // Desativa o botão se já foi respondido
                    : () {
                        // Lógica para verificar resposta falso
                        if (respostaCerta != null && respostaCerta == false) {
                          _marcarExercicioConcluido(index, false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Resposta correta!'),
                                duration: Duration(seconds: 1)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Resposta incorreta!'),
                                duration: Duration(seconds: 1)),
                          );
                          _perderVida();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  backgroundColor:
                      _exerciciosConcluidos[index] && _respostas[index] == false
                          ? (respostaCerta == false ? Colors.green : Colors.red)
                          : Colors.red,
                ),
                child: Text(
                  'Falso',
                  style: TextStyle(
                    fontSize: 16,
                    color: _exerciciosConcluidos[index] &&
                            _respostas[index] == false
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
            ],
          ),
          if (_exerciciosConcluidos[index])
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Exercício concluído!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelaComplete(ConteudoAula conteudo, int index) {
    // Verifica se respostaCorreta é uma string
    String? respostaCerta;
    if (conteudo.respostaCorreta is String) {
      respostaCerta = conteudo.respostaCorreta;
    }

    final TextEditingController respostaController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conteudo.pergunta ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: respostaController,
            enabled: !_exerciciosConcluidos[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sua resposta',
              suffixIcon: _exerciciosConcluidos[index]
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
          ),
          SizedBox(height: 20),
          if (!_exerciciosConcluidos[index])
            ElevatedButton(
              onPressed: () {
                // Lógica para verificar resposta
                final respostaUsuario =
                    respostaController.text.trim().toLowerCase();
                if (respostaCerta != null &&
                    respostaUsuario == respostaCerta.toLowerCase()) {
                  _marcarExercicioConcluido(index, respostaUsuario);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Resposta correta!'),
                        duration: Duration(seconds: 1)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Resposta incorreta!'),
                        duration: Duration(seconds: 1)),
                  );
                  _perderVida();
                }
              },
              child: Text('Verificar'),
            ),
          if (_exerciciosConcluidos[index])
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Exercício concluído!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelaOrdenacao(ConteudoAula conteudo, int index) {
    // Se não houver itens, mostra aviso
    final itensEstado =
        _ordenacaoItens.length > index ? _ordenacaoItens[index] : null;
    if (itensEstado == null || conteudo.itens == null) {
      return Center(child: Text('Nenhum item para ordenar.'));
    }

    // Função que verifica se a ordem atual bate com a ordem correta
    bool verificarOrdenacao() {
      final current = itensEstado;
      final ordemCorreta = conteudo.ordemCorreta;
      if (ordemCorreta == null) {
        // Se não tiver ordem_correta, não conseguimos verificar automaticamente:
        // desative o botão ou retorne false (aqui retornamos false para forçar verificação manual).
        return false;
      }

      // Converte ordemCorreta (List<int>) em lista de strings no mesmo formato de `itens`
      // Suporta tanto índices 0-based quanto 1-based: detectamos pelo valor máximo.
      final itensOriginais = conteudo.itens!;
      List<String> expected;
      try {
        final ord = ordemCorreta;
        final maxVal = ord.reduce((a, b) => a > b ? a : b);
        final minVal = ord.reduce((a, b) => a < b ? a : b);
        if (maxVal > itensOriginais.length) {
          // provavelmente 1-based -> converter para 0-based
          expected = ord.map((v) => itensOriginais[v - 1]).toList();
        } else if (minVal >= 0 && maxVal < itensOriginais.length) {
          // 0-based
          expected = ord.map((v) => itensOriginais[v]).toList();
        } else if (minVal == 1) {
          // também pode ser 1-based
          expected = ord.map((v) => itensOriginais[v - 1]).toList();
        } else {
          // fallback: tenta 0-based
          expected = ord.map((v) => itensOriginais[v]).toList();
        }
      } catch (e) {
        // qualquer erro, não valida automaticamente
        return false;
      }

      return listEquals(current, expected);
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conteudo.pergunta != null)
            Text(
              conteudo.pergunta!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 16),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false, // vamos usar drag handles manuais
              onReorder: (oldIndex, newIndex) {
                // Ajuste para ReorderableListView's behavior
                if (newIndex > oldIndex) newIndex -= 1;
                setState(() {
                  final item = itensEstado.removeAt(oldIndex);
                  itensEstado.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < itensEstado.length; i++)
                  Card(
                    key: ValueKey('ordenacao_${index}_$i'),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(itensEstado[i]),
                      trailing: ReorderableDragStartListener(
                        index: i,
                        child: Icon(Icons.drag_handle),
                      ),
                    ),
                  )
              ],
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: _exerciciosConcluidos[index]
                ? null
                : () {
                    final correto = verificarOrdenacao();
                    if (correto) {
                      _marcarExercicioConcluido(index, List.from(itensEstado));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ordenação correta!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Ordenação incorreta. Tente novamente.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      _perderVida();
                    }
                  },
            child: Text('Verificar ordenação'),
          ),
          if (_exerciciosConcluidos[index])
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Exercício concluído!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelaDesafio(ConteudoAula conteudo) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conteudo.titulo ?? 'Desafio',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            conteudo.pergunta ?? '',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          if (conteudo.dica != null) ...[
            SizedBox(height: 20),
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Dica:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(conteudo.dica!),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigation(AulaDetalhada aula) {
    // Verifica se o exercício atual foi concluído (se for um exercício)
    final currentContent = aula.conteudo[_currentPage];
    final isExercise = currentContent.tipo == 'multipla_escolha' ||
        currentContent.tipo == 'verdadeiro_falso' ||
        currentContent.tipo == 'complete' ||
        currentContent.tipo == 'ordenacao';

    final podeAvancar = !isExercise || _exerciciosConcluidos[_currentPage];

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 0 ? _voltarTela : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CB0F6),
              foregroundColor: Colors.white,
            ),
            child: Text('Voltar'),
          ),
          Text(
            '${_currentPage + 1}/${aula.conteudo.length}',
            style: TextStyle(fontSize: 16),
          ),
          ElevatedButton(
            onPressed: (podeAvancar && !_concluindoAula)
                ? (_currentPage < aula.conteudo.length - 1
                    ? _proximaTela
                    : () async {
                        await _concluirAula();
                        Navigator.pop(context);
                      })
                : null, // Desativa o botão se não pode avançar
            style: ElevatedButton.styleFrom(
              backgroundColor: podeAvancar ? Color(0xFF1CB0F6) : Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: Text(_currentPage < aula.conteudo.length - 1
                ? 'Próximo'
                : 'Finalizar'),
          ),
        ],
      ),
    );
  }
}

// Modelos de dados
class AulaDetalhada {
  final int id;
  final String titulo;
  final String tipo;
  final int progresso;
  final int moduloId;
  final List<ConteudoAula> conteudo;

  AulaDetalhada({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.progresso,
    required this.moduloId,
    required this.conteudo,
  });

  factory AulaDetalhada.fromJson(Map<String, dynamic> json) {
    var list = json['conteudo'] as List;
    List<ConteudoAula> conteudoList =
        list.map((i) => ConteudoAula.fromJson(i)).toList();

    return AulaDetalhada(
      id: json['id'],
      titulo: json['titulo'],
      tipo: json['tipo'],
      progresso: json['progresso'],
      moduloId: json['modulo_id'],
      conteudo: conteudoList,
    );
  }
}

class ConteudoAula {
  final String tipo;
  final String? conteudo;
  final String? titulo;
  final List<String>? passos;
  final String? pergunta;
  final List<String>? opcoes;
  final dynamic respostaCorreta;
  final String? dica;
  final List<String>? itens;
  final List<int>? ordemCorreta;
  final String? descricao;

  ConteudoAula({
    required this.tipo,
    this.conteudo,
    this.titulo,
    this.passos,
    this.pergunta,
    this.opcoes,
    this.respostaCorreta,
    this.dica,
    this.itens,
    this.ordemCorreta,
    this.descricao,
  });

  factory ConteudoAula.fromJson(Map<String, dynamic> json) {
    return ConteudoAula(
      tipo: json['tipo'],
      conteudo: json['conteudo'],
      titulo: json['titulo'],
      passos: json['passos'] != null ? List<String>.from(json['passos']) : null,
      pergunta: json['pergunta'],
      opcoes: json['opcoes'] != null ? List<String>.from(json['opcoes']) : null,
      respostaCorreta: json['resposta_correta'],
      dica: json['dica'],
      itens: json['itens'] != null ? List<String>.from(json['itens']) : null,
      ordemCorreta: json['ordem_correta'] != null
          ? List<int>.from(json['ordem_correta'])
          : null,
      descricao: json['descricao'],
    );
  }
}
