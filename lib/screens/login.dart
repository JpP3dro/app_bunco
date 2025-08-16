import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../uteis/alterar_ip.dart';
import '../uteis/ip.dart';
import 'package:http/http.dart' as http;
import 'cadastro.dart';
import 'telainicial.dart';
import '../uteis/tipo_dialogo.dart';
import 'package:page_transition/page_transition.dart';
import '../uteis/dialogo.dart';
import '../uteis/controle_login.dart';


class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  bool _mostrarSenha = false;
  bool _botaoPressionado = false;
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerLogin = TextEditingController();

  Future<void> fazerLogin() async {
    String ip = obterIP();
    String url = "http://$ip/bunco/api/login.php";

    try {
      if (_controllerSenha.text == "" || _controllerLogin.text == "") {
        await exibirResultado(context: context, tipo: TipoDialogo.alerta, titulo: "Campos não preenchidos", conteudo: "Preencha todos os campos!");
      }
      else {
        http.Response res = await http.post(
          Uri.parse(url),
          body: {
            "login": _controllerLogin.text.trim(),
            "senha": _controllerSenha.text.trim(),
          },
        );
        if (res.statusCode == 200) {
          var user = jsonDecode(res.body);
          if (user["sucesso"] == "true") {
            await salvarLogin(user['id'].toString(), user['username'], context);
            await exibirResultado(context: context, tipo: TipoDialogo.sucesso, titulo: "Usuário logado!", conteudo: "Usuário logado com sucesso!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial(usuario: user, parametroModoEscuro: MediaQuery.of(context).platformBrightness == Brightness.dark,)),
            );
          }
          else {
            await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Login falho!", conteudo: user["mensagem"]);
          }
        }
        else {
          await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Algo deu errado!", conteudo: "Tente novamente daqui mais tarde!");
        }
      }
    } catch (e) {
      await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Erro ao fazer o login", conteudo: "Conexão com o servidor falhou. Tente novamente daqui a pouco!");
    }
  }

  @override
  void dispose() {
    _controllerLogin.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF0D141F),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/telainicial/fundo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Image.asset('assets/images/telainicial/login.png'),
          toolbarHeight: 250,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Color(0x33FFFFFF),),
                onPressed: () {
                  dialogoAlterarIP(context, setState);
                },
              ),
            ),
          ],
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
                //Texto
                Text(
                  "Login",
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
                    controller: _controllerLogin,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Color(0xFF111928),
                            width: 2
                        ),
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
                        "Digite o username ou email:",
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
                    controller: _controllerSenha,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Color(0xFF111928),
                            width: 2
                        ),
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
                        "Digite sua senha:",
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
                  child: GestureDetector(
                    onTapDown: (_) =>
                        setState(() => _botaoPressionado = true),
                    onTapUp: (_) {
                      setState(() => _botaoPressionado = false);
                      fazerLogin();
                    },
                    onTapCancel: () =>
                        setState(() => _botaoPressionado = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      transform: Matrix4.identity()
                        ..translate(0.0, _botaoPressionado ? 5.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F5F7),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: _botaoPressionado
                            ? null
                            : [
                          BoxShadow(
                            color: Color(0xFF2D466C),
                            offset: const Offset(6, 6),
                            blurRadius: 0,
                          )
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Fazer o login",
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color(0xFF1453A3),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                      child: const TelaCadastro(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    )
                ),
                child: const Text("Não tem um usuário? Crie um agora!"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}