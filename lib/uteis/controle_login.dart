import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ip.dart';

late Map<String, dynamic> usuario;
bool parametroModoEscuro = false;

Future<void> salvarLogin(String idUsuario, String username, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('idUsuario', idUsuario);
  await prefs.setString('username', username);
  await dispositivoModoEscuro(context);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<bool> verificarLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('idUsuario');
  if (id == null) {
    return false;
  }

  parametroModoEscuro = prefs.getBool("modoEscuro") ?? false;

  try {
    final url = "http://${obterIP()}/bunco_testes/buscarUsuario.php";
    final response = await http.post(
      Uri.parse(url),
      body: {"login": id},
    );

    debugPrint("Resposta da API: ${response.body}");

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      if (dados["sucesso"] == "true") {
        usuario = dados;
        debugPrint("Usuário encontrado: ${usuario["username"]}");
        return true;
      } else {
        debugPrint("API retornou falso: ${dados["mensagem"]}");
        prefs.clear();
        return false;
      }
    } else {
      debugPrint("Erro HTTP: ${response.statusCode}");
      prefs.clear();
      return false;
    }
  } catch (e) {
    debugPrint("Erro na requisição: $e");
    prefs.clear();
    return false;
  }
}

Future<void> dispositivoModoEscuro(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  await prefs.setBool("modoEscuro", isDark);
}
