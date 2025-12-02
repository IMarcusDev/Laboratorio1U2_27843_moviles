import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laboratorio1u2_27843_app/src/data/datasource/base_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/product_model.dart';


class ProductApiDatasource implements BaseDatasource<ProductModel> {
  final String baseUrl = 'http://localhost:3000/api/productos';

  Future<dynamic> _processResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = json.decode(response.body);
      return body['data'] ?? body; 
    } else {
      throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
    }
  }

  @override
  Future<List<ProductModel>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      final dynamic data = await _processResponse(response);
      return (data as List).map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  @override
  Future<ProductModel> create(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      final dynamic jsonData = await _processResponse(response);
      return ProductModel.fromJson(jsonData);
    } catch (e) {
      throw Exception("Error creating product: $e");
    }
  }

  @override
  Future<ProductModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      final dynamic jsonData = await _processResponse(response);
      return ProductModel.fromJson(jsonData);
    } catch (e) {
      throw Exception("Error updating product: $e");
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }
}