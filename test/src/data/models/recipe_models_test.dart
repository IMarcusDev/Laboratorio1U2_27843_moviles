import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/ingredient_model.dart';

void main() {
  group('Data Layer - Models', () {
    test('RecipeModel.fromJson should parse valid JSON', () {
      final json = {
        "id": "1", "name": "Ceviche", "description": "Rico", "country": "EC",
        "ingredients": [{"name": "A", "quantity": 1, "unit": "kg"}], "steps": ["Paso"]
      };
      final model = RecipeModel.fromJson(json);
      expect(model.name, "Ceviche");
      expect(model.ingredients.first.unit, "kg");
    });

    test('RecipeModel.toJson should NOT include ID', () {
      final model = RecipeModel(id: "1", name: "A", description: "B", country: "C", ingredients: [], steps: []);
      final json = model.toJson();
      expect(json.containsKey('id'), false); // Crítico para tu API
      expect(json['name'], "A");
    });

    test('IngredientModel.fromJson handles numbers correctly', () {
      final json = {"name": "Sal", "quantity": 5, "unit": "g"};
      final model = IngredientModel.fromJson(json);
      expect(model.quantity, 5);
    });
  });
}