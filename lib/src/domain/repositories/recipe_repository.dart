import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();
  Future<Recipe> createRecipe(Recipe recipe);
  Future<Recipe> updateRecipe(String id, Recipe recipe);
  Future<bool> deleteRecipe(String id);
}