import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String country;
  final List<Ingredient> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    required this.ingredients,
    required this.steps,
  });
}
