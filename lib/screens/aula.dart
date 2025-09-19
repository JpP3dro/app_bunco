import 'package:app_bunco/uteis/url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TelaAula extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final int idAula;

  const TelaAula({
    super.key,
    required this.usuario,
    required this.idAula,
  });

  @override
  State<TelaAula> createState() => _TelaAulaState();
}

class _TelaAulaState extends State<TelaAula> {
  late Future<AulaDetalhada> _futureAula;
  int _currentPage = 0;
  late PageController _pageController;
  AulaDetalhada? _aulaData;

  @override
  void initState() {
    super.initState();
    _futureAula = _fetchAulaDetalhada();
    _pageController = PageController();
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
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['sucesso']) {
        setState(() {
          _aulaData = AulaDetalhada.fromJson(data['dados']);
        });
        return _aulaData!;
      } else {
        throw Exception(data['mensagem']);
      }
    } else {
      throw Exception('Falha ao carregar aula');
    }
  }

  void _proximaTela() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Center(child: CircularProgressIndicator());
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
            controller: _pageController,
            itemCount: aula.conteudo.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildTelaConteudo(aula.conteudo[index]);
            },
          ),
        ),

        // Navegação
        _buildNavigation(aula),
      ],
    );
  }

  Widget _buildTelaConteudo(ConteudoAula conteudo) {
    switch (conteudo.tipo) {
      case 'texto':
        return _buildTelaTexto(conteudo);
      case 'exemplo':
        return _buildTelaExemplo(conteudo);
      case 'multipla_escolha':
        return _buildTelaMultiplaEscolha(conteudo);
      case 'verdadeiro_falso':
        return _buildTelaVerdadeiroFalso(conteudo);
      case 'complete':
        return _buildTelaComplete(conteudo);
      case 'ordenacao':
        return _buildTelaOrdenacao(conteudo);
      case 'desafio':
        return _buildTelaDesafio(conteudo);
      default:
        return Center(child: Text('Tipo de conteúdo não suportado'));
    }
  }

  Widget _buildTelaTexto(ConteudoAula conteudo) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Text(
        conteudo.conteudo ?? '',
        style: TextStyle(fontSize: 18, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildTelaExemplo(ConteudoAula conteudo) {
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
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildTelaMultiplaEscolha(ConteudoAula conteudo) {
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
              final index = entry.key;
              final opcao = entry.value;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para verificar resposta
                    if (respostaCerta != null && index == respostaCerta) {
                      // Resposta correta
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Resposta correta!')),
                      );
                    } else {
                      // Resposta incorreta
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Resposta incorreta!')),
                      );
                    }
                  },
                  child: Text(opcao),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTelaVerdadeiroFalso(ConteudoAula conteudo) {
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
                onPressed: () {
                  // Lógica para verificar resposta verdadeiro
                  if (respostaCerta != null && respostaCerta == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Resposta correta!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Resposta incorreta!')),
                    );
                  }
                },
                child: Text('Verdadeiro', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  backgroundColor: Colors.green,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para verificar resposta falso
                  if (respostaCerta != null && respostaCerta == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Resposta correta!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Resposta incorreta!')),
                    );
                  }
                },
                child: Text('Falso', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelaComplete(ConteudoAula conteudo) {
    // Verifica se respostaCorreta é uma string
    String? respostaCerta;
    if (conteudo.respostaCorreta is String) {
      respostaCerta = conteudo.respostaCorreta;
    }

    final TextEditingController _respostaController = TextEditingController();

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
            controller: _respostaController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sua resposta',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Lógica para verificar resposta
              final respostaUsuario = _respostaController.text.trim().toLowerCase();
              if (respostaCerta != null && respostaUsuario == respostaCerta.toLowerCase()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Resposta correta!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Resposta incorreta!')),
                );
              }
            },
            child: Text('Verificar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTelaOrdenacao(ConteudoAula conteudo) {
    // Implementar interface para ordenação
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
          Text('Arraste os itens para ordená-los corretamente',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20),
          // Aqui viria a implementação de arrastar e soltar
          if (conteudo.itens != null)
            ...conteudo.itens!.map((item) => Card(
              child: ListTile(
                title: Text(item),
                trailing: Icon(Icons.drag_handle),
              ),
            )).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text('Verificar ordenação'),
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
            conteudo.descricao ?? '',
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
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 0 ? _voltarTela : null,
            child: Text('Voltar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CB0F6),
              foregroundColor: Colors.white,
            ),
          ),
          Text(
            '${_currentPage + 1}/${aula.conteudo.length}',
            style: TextStyle(fontSize: 16),
          ),
          ElevatedButton(
            onPressed: _currentPage < aula.conteudo.length - 1 ? _proximaTela : () {
              // Lógica para finalizar a aula
              Navigator.pop(context);
            },
            child: Text(_currentPage < aula.conteudo.length - 1 ? 'Próximo' : 'Finalizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CB0F6),
              foregroundColor: Colors.white,
            ),
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
    List<ConteudoAula> conteudoList = list.map((i) => ConteudoAula.fromJson(i)).toList();

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
  final dynamic respostaCorreta; // Alterado para dynamic
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
      respostaCorreta: json['resposta_correta'], // Pode ser int, bool ou string
      dica: json['dica'],
      itens: json['itens'] != null ? List<String>.from(json['itens']) : null,
      ordemCorreta: json['ordem_correta'] != null ? List<int>.from(json['ordem_correta']) : null,
      descricao: json['descricao'],
    );
  }
}