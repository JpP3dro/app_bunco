import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaTerminal extends StatefulWidget {
  const TelaTerminal({super.key});


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
          ]
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
        const SnackBar(
          content: Text("Por favor, escreva algum código Python primeiro!"),
          backgroundColor: Colors.red,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Editor limpo!"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    bool isTablet = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: Color(0xFF0D141F),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Terminal de Python',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isMobile ? 6 : 12),
                        Icon(Icons.terminal, color: const Color(0xFF34d399)),
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
          Card(
            color: const Color(0xFF1e293b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF8b5cf6),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.code, color: Color(0xFFa78bfa)),
                          SizedBox(width: 8),
                          Text(
                            'Editor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: clearCode,
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFf87171)),
                            tooltip: 'Limpar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _codeController,
                    maxLines: 9999,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Digite seu código Python aqui...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF0f172a),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                  child: ElevatedButton.icon(
                    onPressed:
                    isLoading || waitingForInput ? null : executePython,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10b981),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      isLoading
                          ? 'Executando...'
                          : waitingForInput
                          ? 'Input ${currentInputIndex + 1}/${inputsNeeded.length}'
                          : 'Executar',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Console de Saída (Mobile)
          Card(
            color: const Color(0xFF1e293b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF10b981),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal, color: Color(0xFF34d399)),
                      const SizedBox(width: 8),
                      const Text(
                        'Console',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (waitingForInput) ...[
                        const SizedBox(width: 10),
                        Text(
                          '• Input ${currentInputIndex + 1}/${inputsNeeded.length}',
                          style: const TextStyle(
                            color: Color(0xFFfbbf24),
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Text(
                      output.isNotEmpty
                          ? output
                          : '# Console Python Interativo\n# Clique em "Executar" para começar',
                      style: const TextStyle(
                        color: Color(0xFF34d399),
                        fontFamily: 'monospace',
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
                            style: const TextStyle(
                              color: Color(0xFFfbbf24),
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _inputController,
                            autofocus: true,
                            style: const TextStyle(
                              color: Color(0xFF34d399),
                              fontFamily: 'monospace',
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Color(0xFF34d399)),
                                onPressed: () {
                                  handleInputSubmit(_inputController.text);
                                },
                              ),
                              hintText: 'Digite e pressione Enter...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              filled: true,
                              fillColor: const Color(0xFF1e293b),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                const BorderSide(color: Color(0xFF475569)),
                              ),
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
          child: Card(
            color: const Color(0xFF1e293b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF8b5cf6),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.code, color: Color(0xFFa78bfa)),
                          SizedBox(width: 8),
                          Text(
                            'Editor de Código',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                              foregroundColor: const Color(0xFFf87171),
                              side: const BorderSide(color: Color(0xFFef4444)),
                            ),
                            icon: const Icon(Icons.delete, size: 16),
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
                      controller: _codeController,
                      maxLines: 9999,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite seu código Python aqui...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: const Color(0xFF0f172a),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed:
                    isLoading || waitingForInput ? null : executePython,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10b981),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      isLoading
                          ? 'Executando...'
                          : waitingForInput
                          ? 'Coletando Input ${currentInputIndex + 1}/${inputsNeeded.length}'
                          : 'Executar Código',
                      style: const TextStyle(fontSize: 16),
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
          child: Card(
            color: const Color(0xFF1e293b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF10b981),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal, color: Color(0xFF34d399)),
                      const SizedBox(width: 8),
                      const Text(
                        'Console Interativo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (waitingForInput) ...[
                        const SizedBox(width: 10),
                        Text(
                          '• Input ${currentInputIndex + 1}/${inputsNeeded.length}',
                          style: const TextStyle(
                            color: Color(0xFFfbbf24),
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        output.isNotEmpty
                            ? output
                            : '# Terminal de Python Interativo \n# Clique em "Executar Código" para começar',
                        style: const TextStyle(
                          color: Color(0xFF34d399),
                          fontFamily: 'monospace',
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
                          style: const TextStyle(
                            color: Color(0xFFfbbf24),
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            autofocus: true,
                            style: const TextStyle(
                              color: Color(0xFF34d399),
                              fontFamily: 'monospace',
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send,
                                    color: Color(0xFF34d399)),
                                onPressed: () {
                                  handleInputSubmit(_inputController.text);
                                },
                              ),
                              hintText:
                              'Digite sua resposta e pressione Enter...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              filled: true,
                              fillColor: const Color(0xFF1e293b),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                const BorderSide(color: Color(0xFF475569)),
                              ),
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
