import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:laboratorio1u2_27843_app/src/data/datasource/base_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';

class RecipeApiDatasource implements BaseDatasource<RecipeModel> {
  final http.Client client;
  RecipeApiDatasource({http.Client? client}) : client = client ?? http.Client();

  String get baseUrl {
    return 'https://api-recetas-27843-moviles.onrender.com/api/recetas';
  }

  @override
  Future<List<RecipeModel>> fetchAll() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => RecipeModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error trayendo recetas: $e");
      return [];
    }
  }

  @override
  Future<RecipeModel> create(Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return RecipeModel.fromJson(json.decode(response.body));
    }
    throw Exception('Error al crear receta');
  }

  @override
  Future<RecipeModel> update(String id, Map<String, dynamic> data) async {
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return RecipeModel.fromJson(json.decode(response.body));
    }
    throw Exception('Error actualizando receta');
  }

  @override
  Future<bool> delete(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}