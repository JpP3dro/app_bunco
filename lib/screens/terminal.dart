import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../uteis/controle_login.dart';
import '../uteis/dialogo.dart';
import '../uteis/tipo_dialogo.dart';

class TelaTerminal extends StatefulWidget {
  final bool modoEscuro;

  const TelaTerminal({super.key, required this.modoEscuro});

  @override
  State<TelaTerminal> createState() => _TelaTerminalState();
}

class _TelaTerminalState extends State<TelaTerminal> {
  String code = '''# Escreva seu código Python aqui
print("Olá, mundo!")
print("Bem-vindo ao Python Console!")

# Exemplo com input interativo
nome = input("Digite seu nome: ")
print(f"Olá, {nome}!")

idade = input("Digite sua idade: ")
print(f"Você tem {idade} anos")

# Exemplo de operações básicas
x = 10
y = 20
resultado = x + y
print(f"A soma de {x} + {y} = {resultado}")

# Exemplo com lista
numeros = [1, 2, 3, 4, 5]
print("Lista de números:", numeros)
print("Soma da lista:", sum(numeros))''';

  String output = "";
  bool botaoPresionado = false;
  bool isLoading = false;
  bool waitingForInput = false;
  String inputValue = "";
  String currentPrompt = "";
  List<String> inputsNeeded = [];
  int currentInputIndex = 0;
  List<String> collectedInputs = [];
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _codeController.text = code;
  }

  // Função para extrair os prompts de input
  List<String> extractInputPrompts(String code) {
    RegExp inputRegex = RegExp(r'''input\s*\(\s*["\']([^"\']+)["\']\s*\)''');
    List<String> prompts = [];
    Iterable<RegExpMatch> matches = inputRegex.allMatches(code);
    for (RegExpMatch match in matches) {
      if (match.groupCount >= 1) {
        String? prompt = match.group(1);
        if (prompt != null) {
          prompts.add(prompt);
        }
      }
    }
    return prompts;
  }

  // Função para substituir os inputs no código e executar
  Future<void> executeWithAllInputs(
      String codeToExecute, List<String> inputs) async {
    setState(() {
      isLoading = true;
    });

    // Substituir cada input() pelo valor fornecido
    String modifiedCode = codeToExecute;
    int inputIndex = 0;
    modifiedCode = modifiedCode.replaceAllMapped(
      RegExp(r'''input\s*\(\s*["\']([^"\']+)["\']\s*\)'''),
      (match) {
        if (inputIndex < inputs.length) {
          return '"${inputs[inputIndex++]}";';
        }
        return match.group(0)!;
      },
    );

    // Executar via API
    try {
      if (!await verificarConexao()) {
        await exibirResultado(
            context: context,
            tipo: TipoDialogo.erro,
            titulo: "Sem conexão",
            conteudo:
                "Seu dispositivo está sem internet. Tente novamente quando tiver internet.");
        return;
      }
      final response = await http.post(
        Uri.parse('https://emkc.org/api/v2/piston/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': 'python',
          'version': '3.10.0',
          'files': [
            {
              'name': 'main.py',
              'content': modifiedCode,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['run'] != null) {
          if (data['run']['output'] != null) {
            setState(() {
              output = data['run']['output'];
            });
          } else if (data['run']['stderr'] != null) {
            setState(() {
              output = "Erro:\n${data['run']['stderr']}";
            });
          }
        }
      } else {
        setState(() {
          output = "Erro na requisição: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        output = "Erro de conexão: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void executePython() {
    if (code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Por favor, escreva algum código Python primeiro!",
            style: GoogleFonts.baloo2(fontSize: 16),
          ),
          backgroundColor: Color(0xFFEA2B2B),
        ),
      );
      return;
    }

    List<String> prompts = extractInputPrompts(code);
    if (prompts.isEmpty) {
      // Executar diretamente
      setState(() {
        output = "Executando código...\n";
      });
      executeWithAllInputs(code, []);
    } else {
      // Entrar em modo de coleta
      setState(() {
        inputsNeeded = prompts;
        currentInputIndex = 0;
        collectedInputs = [];
        currentPrompt = prompts[0];
        waitingForInput = true;
        inputValue = "";
        output =
            "Preparando execução...\nInputs necessários: ${prompts.length}\n\n";
      });
    }
  }

  void handleInputSubmit(String value) {
    if (value.trim().isEmpty) return;

    setState(() {
      collectedInputs.add(value.trim());
      output += "$currentPrompt${value.trim()}\n";
      inputValue = "";
      _inputController.clear();
    });

    if (currentInputIndex + 1 < inputsNeeded.length) {
      // Ainda há mais inputs
      setState(() {
        currentInputIndex++;
        currentPrompt = inputsNeeded[currentInputIndex];
      });
    } else {
      // Todos os inputs coletados, executar
      setState(() {
        waitingForInput = false;
        output += "\nExecutando código...\n";
      });
      executeWithAllInputs(code, collectedInputs);
    }
  }

  void clearCode() {
    setState(() {
      code = "";
      output = "";
      waitingForInput = false;
      inputsNeeded = [];
      currentInputIndex = 0;
      collectedInputs = [];
      inputValue = "";
      currentPrompt = "";
      _codeController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    bool isTablet = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: widget.modoEscuro ? Color(0xFF0D141F) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Cabeçalho responsivo
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Terminal de Python",
                          style: GoogleFonts.baloo2(
                            color: widget.modoEscuro
                                ? Color(0xFFB0C2DE)
                                : Color(0xFF1CB0F6),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Corpo principal - Layout responsivo
              Expanded(
                child: isMobile
                    ? buildMobileLayout()
                    : buildDesktopLayout(isTablet),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Editor de Código (Mobile)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: 400,
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: const Color(0xFF1e293b),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  offset: Offset(7, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Editor',
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: clearCode,
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFef4444)),
                            tooltip: 'Limpar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    cursorColor: Color(0xFF1cB0F6),
                    controller: _codeController,
                    maxLines: 9999,
                    style: GoogleFonts.firaCode(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Digite seu código Python aqui...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF151923),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        code = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() => botaoPresionado = true);
                    },
                    onTapUp: (_) {
                      setState(() => botaoPresionado = false);
                      FocusScope.of(context).unfocus();
                      isLoading || waitingForInput ? null : executePython();
                    },
                    onTapCancel: () => setState(() => botaoPresionado = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(0.0, botaoPresionado ? 5.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1CB0F6),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: botaoPresionado
                            ? null
                            : [
                                BoxShadow(
                                  color: const Color(0xFF1453A3),
                                  offset: const Offset(6, 6),
                                  blurRadius: 0,
                                )
                              ],
                      ),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoading
                                  ? 'Executando...'
                                  : waitingForInput
                                      ? 'Input ${currentInputIndex + 1}/${inputsNeeded.length}'
                                      : 'Executar',
                              style: GoogleFonts.baloo2(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Console de Saída (Mobile)
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: const Color(0xFF1e293b),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  offset: Offset(7, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Console',
                        style: GoogleFonts.baloo2(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      if (waitingForInput) ...[
                        const SizedBox(width: 10),
                        Text(
                          '• Input ${currentInputIndex + 1}/${inputsNeeded.length}',
                          style: const TextStyle(
                            color: Color(0xFF586892),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF151923),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Text(
                      output.isNotEmpty
                          ? output
                          : '# Terminal de Python Interativo',
                      style: GoogleFonts.firaCode(
                        color: Color(0xFF34d399),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (waitingForInput)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            currentPrompt,
                            style: GoogleFonts.baloo2(
                                color: Color(0xFFB0C2DE),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            cursorColor: Color(0xFF1CB0F6),
                            controller: _inputController,
                            autofocus: true,
                            style: GoogleFonts.baloo2(
                                color: Color(0xFF1CB0F6),
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xFF1CB0F6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color(0xFF1CB0F6), width: 2),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Color(0xFF1CB0F6)),
                                onPressed: () {
                                  handleInputSubmit(_inputController.text);
                                },
                              ),
                              hintText: 'Digite e pressione Enter...',
                              hintStyle: GoogleFonts.baloo2(
                                  color: Color(0xFF1CB0F6),
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: const Color(0xFF1e293b),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            onSubmitted: (value) {
                              handleInputSubmit(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopLayout(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Editor de Código
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFF1e293b),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  offset: Offset(7, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Editor de Código',
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: clearCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1e293b),
                              foregroundColor: const Color(0xFFEA2B2B),
                              side: const BorderSide(color: Color(0xFFef4444)),
                            ),
                            icon: const Icon(Icons.delete,
                                size: 16, color: Color(0xFFef4444)),
                            label: const Text('Limpar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      cursorColor: Color(0xFF1cB0F6),
                      controller: _codeController,
                      maxLines: 9999,
                      style: GoogleFonts.firaCode(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite seu código Python aqui...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: const Color(0xFF151923),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          code = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() => botaoPresionado = true);
                    },
                    onTapUp: (_) {
                      setState(() => botaoPresionado = false);
                      FocusScope.of(context).unfocus();
                      isLoading || waitingForInput ? null : executePython();
                    },
                    onTapCancel: () => setState(() => botaoPresionado = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(0.0, botaoPresionado ? 5.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1CB0F6),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: botaoPresionado
                            ? null
                            : [
                                BoxShadow(
                                  color: const Color(0xFF1453A3),
                                  offset: const Offset(6, 6),
                                  blurRadius: 0,
                                )
                              ],
                      ),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoading
                                  ? 'Executando...'
                                  : waitingForInput
                                      ? 'Input ${currentInputIndex + 1}/${inputsNeeded.length}'
                                      : 'Executar',
                              style: GoogleFonts.baloo2(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Console de Saída
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFF1e293b),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  offset: Offset(7, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Console',
                        style: GoogleFonts.baloo2(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      if (waitingForInput) ...[
                        const SizedBox(width: 10),
                        Text(
                          '• Input ${currentInputIndex + 1}/${inputsNeeded.length}',
                          style: const TextStyle(
                            color: Color(0xFF586892),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF151923),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        output.isNotEmpty
                            ? output
                            : '# Terminal de Python Interativo',
                        style: GoogleFonts.firaCode(
                          color: Color(0xFF34d399),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                if (waitingForInput)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          currentPrompt,
                          style: GoogleFonts.baloo2(
                              color: Color(0xFFB0C2DE),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: Color(0xFF1CB0F6),
                            controller: _inputController,
                            autofocus: true,
                            style: GoogleFonts.baloo2(
                                color: Color(0xFF1CB0F6),
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xFF1CB0F6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color(0xFF1CB0F6), width: 2),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Color(0xFF1CB0F6)),
                                onPressed: () {
                                  handleInputSubmit(_inputController.text);
                                },
                              ),
                              hintText:
                                  'Digite sua resposta e pressione Enter...',
                              hintStyle: TextStyle(color: Color(0xFF1CB0F6)),
                              filled: true,
                              fillColor: const Color(0xFF1e293b),
                            ),
                            onSubmitted: (value) {
                              handleInputSubmit(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
