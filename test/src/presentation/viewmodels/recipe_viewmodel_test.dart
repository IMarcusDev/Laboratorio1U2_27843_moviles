import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_recipes_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_recipe_usecase.dart';
import '../../../../test/helpers/test_mocks.dart';

void main() {
  late RecipeViewmodel viewModel;
  late MockRecipeRepository mockRepo;

  setUp(() {
    mockRepo = MockRecipeRepository();
    viewModel = RecipeViewmodel(
      GetRecipesUseCase(mockRepo),
      CreateRecipeUsecase(mockRepo),
      UpdateRecipesUseCase(mockRepo),
      DeleteRecipeUsecase(mockRepo),
    );
  });

  group('Presentation Layer - RecipeViewModel', () {
    test('Initial state is correct', () {
      expect(viewModel.loading, false);
      expect(viewModel.visibleRecipes, isEmpty);
    });

    test('cargarRecetas loads data successfully', () async {
      await viewModel.cargarRecetas();
      expect(viewModel.loading, false);
      expect(viewModel.visibleRecipes.length, 1);
    });

    test('agregarRecetas calls usecase and reloads', () async {
      final r = Recipe(id: '1', name: 'New', description: 'D', country: 'C', ingredients: [], steps: []);
      await viewModel.agregarRecetas(r);
      expect(viewModel.visibleRecipes.isNotEmpty, true);
    });

    test('Handles errors gracefully', () async {
      mockRepo.shouldFail = true; // Activar fallo simulado
      await viewModel.cargarRecetas(); // No debe lanzar excepción
      expect(viewModel.loading, false);
      expect(viewModel.visibleRecipes, isEmpty);
    });
  });
}