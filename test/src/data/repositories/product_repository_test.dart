import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/data/repositories/product_repository_impl.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import '../../../../test/helpers/test_mocks.dart';

void main() {
  group('Data Layer - Repository Implementation', () {
    test('getRecipes calls datasource fetchAll', () async {
      final mockDs = MockRecipeDatasource();
      final repo = RecipeRepositoryImpl(mockDs);
      // El mock devuelve lista vacía
      expect(await repo.getRecipes(), isEmpty);
    });

    test('createRecipe calls datasource create', () async {
      final mockDs = MockRecipeDatasource();
      final repo = RecipeRepositoryImpl(mockDs);
      final recipe = RecipeModel(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);
      
      final result = await repo.createRecipe(recipe);
      expect(result.id, '123'); // ID retornado por el mock
    });
  });
}