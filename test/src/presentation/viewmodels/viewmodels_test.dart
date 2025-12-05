import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_recipes_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_recipe_usecase.dart';
import '../../../helpers/test_mocks.dart';

void main() {
  group('RecipeViewModel', () {
    late RecipeViewmodel vm;
    late MockRecipeRepository mockRepo;

    setUp(() {
      mockRepo = MockRecipeRepository();
      vm = RecipeViewmodel(
        GetRecipesUseCase(mockRepo),
        CreateRecipeUsecase(mockRepo),
        UpdateRecipesUseCase(mockRepo),
        DeleteRecipeUsecase(mockRepo),
      );
    });

    test('cargarRecetas Success', () async {
      await vm.cargarRecetas();
      expect(vm.loading, false);
      expect(vm.visibleRecipes.isNotEmpty, true);
    });

    test('cargarRecetas Error', () async {
      mockRepo.shouldFail = true;
      await vm.cargarRecetas();
      expect(vm.loading, false);
      expect(vm.visibleRecipes, isEmpty);
    });

    test('CRUD operations', () async {
      final r = Recipe(id: '1', name: 'N', description: 'D', country: 'C', ingredients: [], steps: []);
      await vm.agregarRecetas(r);
      await vm.actualizarProducto('1', r);
      await vm.eliminarProducto('1');
      expect(vm.loading, false);
    });

    test('Pagination (cargarMas)', () async {
      await vm.cargarRecetas();
      await vm.cargarMas();
      expect(vm.isLoadingMore, false);
    });
  });
}