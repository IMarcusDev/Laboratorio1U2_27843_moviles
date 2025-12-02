import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<List<Recipe>> call() => repository.getRecipes();
}