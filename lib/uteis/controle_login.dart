import 'dart:convert';
import 'package:app_bunco/uteis/ip.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

late Map<String, dynamic> usuario;
bool parametroModoEscuro = false;

Future<void> salvarLogin(String idUsuario, String username, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('idUsuario', idUsuario);
  await prefs.setString('username', username);
  await prefs.setBool('modoEscuro', await dispositivoModoEscuro(context));
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<bool> verificarLogin(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('idUsuario');
  if (id == null) {
    return false;
  }
  dispositivoModoEscuro(context);
  parametroModoEscuro = prefs.getBool("modoEscuro") ?? false;

  try {
    final response = await http.post(
      Uri.parse("http://${obterIP()}buscar_usuario.php"),
      body: {"login": int.parse(id)},
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      if (dados["sucesso"] == "true") {
        usuario = dados;
        return true;
      } else {
        prefs.clear();
        return false;
      }
    } else {
      prefs.clear();
      return false;
    }
  } catch (e) {
    prefs.clear();
    return false;
  }
}

Future<bool> dispositivoModoEscuro(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("modoEscuro", MediaQuery.of(context).platformBrightness == Brightness.dark);
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}