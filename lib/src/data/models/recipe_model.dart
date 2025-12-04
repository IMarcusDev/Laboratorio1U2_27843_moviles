import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'ingredient_model.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.country,
    required super.ingredients,
    required super.steps,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      country: json['country'],
      ingredients: (json['ingredients'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      steps: List<String>.from(json['steps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'country': country,
      'ingredients': ingredients
          .map((ingredient) => IngredientModel(
                name: ingredient.name,
                quantity: ingredient.quantity,
                unit: ingredient.unit,
              ).toJson())
          .toList(),
      'steps': steps,
    };
  }
}
