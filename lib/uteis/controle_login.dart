import 'dart:convert';
import 'package:app_bunco/uteis/dialogo.dart';
import 'package:app_bunco/uteis/tipo_dialogo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

late Map<String, dynamic> usuario;

Future<bool> verificarConexao() async {
  var result = await Connectivity().checkConnectivity();
  if (result != ConnectivityResult.none) {
    return true;
  }
  else {
    return false;
  }
}

Future<void> salvarLogin(String idUsuario, String username, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('idUsuario', idUsuario);
  await prefs.setString('username', username);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  String? urlSalva = prefs.getString('url');

  await prefs.clear();
  if (urlSalva != null) {
    await prefs.setString('ip', urlSalva);
  }
}


Future<bool> verificarLogin(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('idUsuario');
  if (id == null) {
    return false;
  }
  if (!await verificarConexao()) {
    await exibirResultado(
        context: context,
        tipo: TipoDialogo.erro,
        titulo: "Sem conexão",
        conteudo: "Seu dispositivo está sem internet. Tente novamente quando tiver internet."
    );
    return false;
  }

  try {
    final link = "${obterUrl()}/api/buscarUsuario.php";
    final response = await http.post(
      Uri.parse(link),
      body: {"login": id},
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      if (dados["sucesso"] == "true") {
        usuario = dados;
        //await exibirResultado(context: context, tipo: TipoDialogo.sucesso, titulo: "Deu certo!", conteudo: "OK!");
        return true;
      } else {
        //await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "API retornou false", conteudo: response.body);
        prefs.clear();
        return false;
      }
    } else {
      //await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Código HTTP não é 200", conteudo: response.statusCode.toString());
      prefs.clear();
      return false;
    }
  } catch (e) {
    //await exibirResultado(context: context, tipo: TipoDialogo.erro, titulo: "Erro na requisição", conteudo: e.toString());
    prefs.clear();
    return false;
  }
}

