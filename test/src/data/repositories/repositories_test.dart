import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/data/repositories/product_repository_impl.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import '../../../helpers/test_mocks.dart';

void main() {
  test('RecipeRepositoryImpl delegates to datasource', () async {
    final mockDs = MockRecipeDatasource();
    final repo = RecipeRepositoryImpl(mockDs);
    
    // getRecipes
    expect(await repo.getRecipes(), isEmpty);
    
    // createRecipe
    final r = RecipeModel(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);
    final created = await repo.createRecipe(r);
    expect(created.id, '123'); // ID del mock
  });
}