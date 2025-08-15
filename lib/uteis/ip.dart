import 'package:shared_preferences/shared_preferences.dart';

String ipAtual = "192.168.15.10"; // valor padrão

Future<void> carregarIP() async {
  final prefs = await SharedPreferences.getInstance();
  ipAtual = prefs.getString('ip') ?? "192.168.15.10";
}

String obterIP() {
  return ipAtual;
}

Future<void> alterarIP(String ipNovo) async {
  ipAtual = ipNovo;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('ip', ipNovo);
}
