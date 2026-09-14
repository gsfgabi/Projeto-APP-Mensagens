import 'package:cloud_functions/cloud_functions.dart';

class FuncoesUnichat {
  static final _fn = FirebaseFunctions.instance;

  static Future<List<String>> listarNomesTurmas() async {
    final res = await _fn.httpsCallable('listarNomesTurmas').call();
    final data = Map<String, dynamic>.from(res.data as Map);
    final names = (data['names'] as List?) ?? [];
    return names.map((item) => item.toString()).toList();
  }

  static Future<void> entrarTurma(String codigo) async {
    await _fn.httpsCallable('entrarTurma').call({
      'codigo': codigo.trim().toUpperCase(),
    });
  }

  static Future<void> criarContaEquipe({
    required String email,
    required String password,
    required String nome,
    required String papel,
    required String convite,
  }) async {
    await _fn.httpsCallable('criarContaEquipe').call({
      'email': email,
      'password': password,
      'nome': nome,
      'papel': papel,
      'convite': convite,
    });
  }
}
