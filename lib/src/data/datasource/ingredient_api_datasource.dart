import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:laboratorio1u2_27843_app/src/data/models/ingredient_model.dart';

class IngredientApiDatasource {
  String get baseUrl {
    return 'https://api-recetas-27843-moviles.onrender.com/api/ingredientes';
  }

  Future<List<IngredientModel>> getIngredients() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => IngredientModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error obteniendo ingredientes: $e");
      return [];
    }
  }

  Future<bool> createIngredient(IngredientModel ingredient) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(ingredient.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error creando ingrediente: $e");
      return false;
    }
  }

  Future<bool> updateIngredient(String id, IngredientModel ingredient) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': ingredient.name,
          'description': ingredient.description,
          'calories': ingredient.calories,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error actualizando ingrediente: $e");
      return false;
    }
  }

  Future<bool> deleteIngredient(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }
}