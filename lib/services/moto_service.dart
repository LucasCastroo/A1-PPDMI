import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/moto.dart';

class MotoService {
  static const String baseUrl = 'https://motos-api.free.beeceptor.com/api/motos';

  static Future<List<Moto>> getMotos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Moto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar motos');
    }
  }

  static Future<void> addMoto(Moto moto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(moto.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao adicionar moto');
    }
  }

  static Future<void> updateMoto(Moto moto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${moto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(moto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar moto');
    }
  }

  static Future<void> deleteMoto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar moto');
    }
  }
}
