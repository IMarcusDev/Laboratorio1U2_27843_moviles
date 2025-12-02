import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';

class UpdateRecipesUseCase {
  final RecipeRepository repository;

  UpdateRecipesUseCase(this.repository);

  Future<Recipe> call(String id, Recipe r) => repository.updateRecipe(id, r);
}