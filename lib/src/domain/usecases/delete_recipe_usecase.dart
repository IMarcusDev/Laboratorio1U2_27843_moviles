import 'package:laboratorio1u2_27843_app/src/domain/repositories/recipe_repository.dart';

class DeleteRecipeUsecase {
  final RecipeRepository repository;

  DeleteRecipeUsecase(this.repository);

  Future<bool> call(String id) => repository.deleteRecipe(id);
}