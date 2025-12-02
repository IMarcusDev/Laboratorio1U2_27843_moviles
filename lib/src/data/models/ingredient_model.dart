import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  IngredientModel({
    required super.name,
    required super.quantity,
    required super.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}