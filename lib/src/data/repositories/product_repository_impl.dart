import 'package:laboratorio1u2_27843_app/src/data/datasource/recipe_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApiDatasource datasource;

  RecipeRepositoryImpl(this.datasource);

  @override
  Future<List<Recipe>> getRecipes() async {
    return await datasource.fetchAll();
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    final recipeModel = RecipeModel(
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      country: recipe.country,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
    );

    return await datasource.create(recipeModel.toJson());
  }

  @override
  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    final recipeModel = RecipeModel(
      id: id,
      name: recipe.name,
      description: recipe.description,
      country: recipe.country,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
    );

    return await datasource.update(id, recipeModel.toJson());
  }

  @override
  Future<bool> deleteRecipe(String id) async {
    return await datasource.delete(id);
  }
}
