import 'package:shared_preferences/shared_preferences.dart';

String urlAtual = "https://bunco.alwaysdata.net"; // valor para a web
//String urlAtual = "http://ipdamaquina/bunco"; // valor local

Future<void> carregarUrl() async {
  final prefs = await SharedPreferences.getInstance();
  urlAtual = prefs.getString('url') ?? "https://bunco.alwaysdata.net";
}

String obterUrl() {
  return urlAtual;
}

Future<void> alterarUrl(String urlNova) async {
  urlAtual = urlNova;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('url', urlNova);
}
