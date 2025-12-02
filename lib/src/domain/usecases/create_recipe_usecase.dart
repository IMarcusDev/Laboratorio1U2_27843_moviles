import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';

class CreateRecipeUsecase {
  final RecipeRepository repository;

  CreateRecipeUsecase(this.repository);

  Future<Recipe> call(Recipe r) => repository.createRecipe(r);
}