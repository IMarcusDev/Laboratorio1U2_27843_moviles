import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laboratorio1u2_27843_app/src/data/datasource/base_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';

class RecipeApiDatasource implements BaseDatasource<RecipeModel> {
  final String baseUrl = 'http://localhost:3000/api/recetas';

  Future<dynamic> _processResponse(http.Response response) async {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded['data'] ?? decoded;
        }

        if (decoded is List) return decoded;

        return null;
      } catch (e) {
        throw Exception('Respuesta no es JSON válido: ${response.body}');
      }
    }

    // ERROR HTTP
    throw Exception('Error HTTP $statusCode\n${response.body}');
  }

  @override
  Future<List<RecipeModel>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      final data = await _processResponse(response);

      if (data is List) {
        return data.map((item) => RecipeModel.fromJson(item)).toList();
      }

      throw Exception("Datos inesperados al obtener recetas: $data");
    } catch (e) {
      throw Exception("Error fetching recipes: $e");
    }
  }

  @override
  Future<RecipeModel> create(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final jsonData = await _processResponse(response);

      if (jsonData is Map<String, dynamic>) {
        return RecipeModel.fromJson(jsonData);
      }

      throw Exception("Datos inesperados al crear receta: $jsonData");
    } catch (e) {
      throw Exception("Error creating recipe: $e");
    }
  }

  @override
  Future<RecipeModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final jsonData = await _processResponse(response);

      if (jsonData is Map<String, dynamic>) {
        return RecipeModel.fromJson(jsonData);
      }

      throw Exception("Datos inesperados al actualizar receta: $jsonData");
    } catch (e) {
      throw Exception("Error updating recipe: $e");
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      throw Exception("Error deleting recipe: $e");
    }
  }
}
