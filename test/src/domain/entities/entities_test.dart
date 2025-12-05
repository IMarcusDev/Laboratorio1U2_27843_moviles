import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';

void main() {
  group('Domain Layer - Entities', () {
    test('Recipe entity properties', () {
      final recipe = Recipe(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);
      expect(recipe.id, '1');
      expect(recipe.ingredients, isEmpty);
    });

    test('Ingredient entity properties', () {
      final ingredient = Ingredient(name: 'Sal', quantity: 1, unit: 'g');
      expect(ingredient.name, 'Sal');
    });
  });
}