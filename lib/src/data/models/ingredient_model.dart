import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  IngredientModel({
    super.id,
    required super.name,
    super.description,
    super.calories,
    super.quantity,
    super.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      calories: json['calories'],
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (calories != null) 'calories': calories,
      'quantity': quantity,
      'unit': unit,
    };
  }
}