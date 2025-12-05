import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/ingredient_model.dart';

void main() {
  group('Data Layer - Models', () {
    test('RecipeModel.fromJson', () {
      final json = {"id": "1", "name": "A", "description": "B", "country": "C", "ingredients": [], "steps": []};
      final model = RecipeModel.fromJson(json);
      expect(model.name, "A");
    });

    test('RecipeModel.toJson NO debe tener ID', () {
      final model = RecipeModel(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);
      final json = model.toJson();
      expect(json.containsKey('id'), false); // Validación de tu corrección
    });

    test('IngredientModel.fromJson/toJson', () {
      final json = {"name": "Sal", "quantity": 1, "unit": "g"};
      final model = IngredientModel.fromJson(json);
      expect(model.unit, "g");
      expect(model.toJson()['name'], "Sal");
    });
  });
}