import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/recipe_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';

class MockRecipeRepository implements RecipeRepository {
  bool shouldFail = false; // Interruptor para simular errores

  @override
  Future<List<Recipe>> getRecipes() async {
    if (shouldFail) throw Exception('Error de red');
    return [Recipe(id: '1', name: 'Mock', description: 'Desc', country: 'EC', ingredients: [], steps: [])];
  }

  @override
  Future<Recipe> createRecipe(Recipe r) async {
    if (shouldFail) throw Exception('Error creando');
    return r;
  }

  @override
  Future<Recipe> updateRecipe(String id, Recipe r) async {
    if (shouldFail) throw Exception('Error actualizando');
    return r;
  }

  @override
  Future<bool> deleteRecipe(String id) async {
    if (shouldFail) throw Exception('Error borrando');
    return true;
  }
}

class MockRecipeDatasource extends RecipeApiDatasource {
  @override
  Future<List<RecipeModel>> fetchAll() async => [];
  
  @override
  Future<RecipeModel> create(Map<String, dynamic> data) async => 
      RecipeModel(id: '123', name: 'Test', description: 'D', country: 'C', ingredients: [], steps: []);
}
