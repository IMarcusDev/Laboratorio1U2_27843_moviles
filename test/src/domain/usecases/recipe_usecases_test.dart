import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_recipes_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import '../../../../test/helpers/test_mocks.dart';

void main() {
  final mockRepo = MockRecipeRepository();
  final tRecipe = Recipe(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);

  group('Domain Layer - UseCases', () {
    test('GetRecipesUseCase calls repository', () async {
      final usecase = GetRecipesUseCase(mockRepo);
      final result = await usecase();
      expect(result.length, 1);
    });

    test('CreateRecipeUseCase calls repository', () async {
      final usecase = CreateRecipeUsecase(mockRepo);
      final result = await usecase(tRecipe);
      expect(result.name, 'A');
    });
  });
}