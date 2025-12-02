import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['nombre'] ?? 'Sin nombre',
      price: double.tryParse(json['precio'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      category: json['categoria'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": name,
      "precio": price,
      "stock": stock,
      "categoria": category,
    };
  }
}