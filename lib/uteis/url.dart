import 'package:shared_preferences/shared_preferences.dart';

//String urlAtual = "https://bunco.alwaysdata.net"; // valor para a web
String urlAtual = "http://192.168.15.8/bunco_testes"; // valor local

Future<void> carregarUrl() async {
  final prefs = await SharedPreferences.getInstance();
  //urlAtual = prefs.getString('url') ?? "https://bunco.alwaysdata.net";
  urlAtual = prefs.getString('url') ?? "http://192.168.15.8/bunco_testes";
}

Future<String> obterUrl() async {
  await carregarUrl();
  return urlAtual;
}

Future<void> alterarUrl(String urlNova) async {
  urlAtual = urlNova;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('url', urlNova);
}
