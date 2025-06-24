import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../uteis/ip.dart';
import 'login.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:page_transition/page_transition.dart';
import '../uteis/dialogo.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  bool _mostrarSenha = false;

  Future<void> fazerCadastro() async {
    if (!(_controllerNome.text.isNotEmpty && _controllerUsername.text.isNotEmpty &&
        _controllerEmail.text.isNotEmpty && _controllerSenha.text.isNotEmpty)) {
      await exibirResultado(
          context: context, tipo: TipoDialogo.alerta, titulo: "Campos vazios", conteudo: "Preencha todos os campos!");
    } else {
      try {
        if (_controllerUsername.text.trim().contains(' ')) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Username com espaço!", conteudo: "A username não pode conter espaços!");
          return;
        }
        final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
        if (!regex.hasMatch(_controllerEmail.text)) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Email inválido!", conteudo: "Digite um email válido!");
          return;
        }
        if (_controllerNome.text.trim().length < 4 || _controllerUsername.text.trim().length < 4) {
          await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Nome ou username muito pequeno", conteudo: "O nome e o username precisam ter no mínimo 4 caracteres!");
          return;
        }
        String ip = obterIP();
        String url = "http://$ip/bunco/api/cadastrar.php";
        var res = await http.post(Uri.parse(url), body: {
          "username": _controllerUsername.text.trim(),
          "nome": _controllerNome.text,
          "email": _controllerEmail.text,
          "senha": _controllerSenha.text
        }).timeout(const Duration(minutes: 1));
        var response = jsonDecode(res.body);
        await exibirResultado(
          context: context,
          tipo: response["sucesso"] == "true"
          ? TipoDialogo.sucesso
          : TipoDialogo.erro,
          titulo: response["sucesso"] == "true"
              ? "Sucesso!"
              : "Erro!",
          conteudo: response["sucesso"] == "true"
              ? "Registro salvo com sucesso!"
              : response["mensagem"],
        );
      }
      catch (e) {
        await exibirResultado(
          context: context,
          tipo: TipoDialogo.erro,
          titulo: "Erro crítico",
          conteudo: "Falha na conexão com o servidor! Tente novamente daqui a um tempo.",
        );
      }
    }
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget é descartado
    _controllerNome.dispose();
    _controllerUsername.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF0D141F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/telainicial/fundo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Center(
          child: Image.asset('assets/images/telainicial/cadastro.png'),
        ),
        toolbarHeight: 250,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            kToolbarHeight,
            decoration: BoxDecoration(
              color: Color(0xFF586892),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(70),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cadastro",
                    style: GoogleFonts.baloo2(
                        fontSize: 48,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Color(0xFF1cB0F6),
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _controllerNome,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF111928),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF1CB0F6),
                            width: 2,
                          ),
                        ),
                        label: Text(
                          "Digite um nome:",
                          style: GoogleFonts.baloo2(
                              fontSize: 20,
                              color: Color(0xFFB0C2DE),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Color(0xFF0D141F),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Color(0xFF1cB0F6),
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _controllerUsername,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF111928),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF1CB0F6),
                            width: 2,
                          ),
                        ),
                        label: Text(
                          "Digite um nome de usuário:",
                          style: GoogleFonts.baloo2(
                              fontSize: 20,
                              color: Color(0xFFB0C2DE),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: Icon(
                          Icons.switch_account,
                          color: Color(0xFF0D141F),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Color(0xFF1cB0F6),
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF111928),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF1CB0F6),
                            width: 2,
                          ),
                        ),
                        label: Text(
                          "Digite um email:",
                          style: GoogleFonts.baloo2(
                              fontSize: 20,
                              color: Color(0xFFB0C2DE),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: Icon(
                          Icons.mark_email_read,
                          color: Color(0xFF0D141F),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Color(0xFF1cB0F6),
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: _controllerSenha,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF111928),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF1CB0F6),
                            width: 2,
                          ),
                        ),
                        label: Text(
                          "Coloque uma senha:",
                          style: GoogleFonts.baloo2(
                              fontSize: 20,
                              color: Color(0xFFB0C2DE),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: const Icon(
                          Icons.password,
                          color: Color(0xFF0D141F),
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _mostrarSenha == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF1CB0F6),
                          ),
                          onTap: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                      ),
                      obscureText: _mostrarSenha == false ? true : false,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        textStyle: GoogleFonts.baloo2(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        backgroundColor: Color(0xFF111928),
                        foregroundColor: Color(0xFF1453A3),
                      ),
                      onPressed: () {
                        fazerCadastro();
                      },
                      child: const Text("Criar um novo usuário"),
                    ),
                  ),
                ],
              ),
            ),
          ),
      bottomNavigationBar: Container(
        height: 80,
        color: Color(0xFF586892),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: GoogleFonts.baloo2(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                backgroundColor: Color(0xFF0D141F),
                foregroundColor: Color(0xFF1CB0F6),
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: const TelaLogin(),
                    type: PageTransitionType.leftToRight,
                    duration: const Duration(milliseconds: 500),
                  )
              ),
              child: const Text("Já tem um usuário? Clique aqui para logar!"),
            ),
          ),
        ),
      ),
    );
  }
}