import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_recipes_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/base_viewmodel.dart';
import 'package:flutter/foundation.dart';

class RecipeViewmodel extends BaseViewModel {
  final GetRecipesUseCase getRecipesUseCase;
  final CreateRecipeUsecase createRecipeUsecase;
  final UpdateRecipesUseCase updateRecipesUseCase;
  final DeleteRecipeUsecase deleteRecipeUsecase;

  List<Recipe> _allRecipes = [];
  List<Recipe> visibleRecipes = [];

  int _currentIndex = 0;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  RecipeViewmodel(
    this.getRecipesUseCase,
    this.createRecipeUsecase,
    this.updateRecipesUseCase,
    this.deleteRecipeUsecase,
  );

  Future<void> cargarRecetas() async {
    setLoading(true);
    try {
      _allRecipes = await getRecipesUseCase();

      // reset pagination
      _currentIndex = 0;
      _hasMore = true;
      visibleRecipes = [];

      _loadMoreInternal();
    } catch (e) {
      debugPrint("Error cargando: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void _loadMoreInternal() {
    final nextIndex = _currentIndex + _pageSize;

    if (_currentIndex >= _allRecipes.length) {
      _hasMore = false;
      return;
    }

    final nextChunk = _allRecipes.sublist(
      _currentIndex,
      nextIndex > _allRecipes.length ? _allRecipes.length : nextIndex,
    );

    visibleRecipes.addAll(nextChunk);
    _currentIndex = nextIndex;

    if (_currentIndex >= _allRecipes.length) {
      _hasMore = false;
    }
  }

  Future<void> cargarMas() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300)); // UX suave

    _loadMoreInternal();

    _isLoadingMore = false;
    notifyListeners();
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> agregarRecetas(Recipe r) async {
    setLoading(true);
    try {
      await createRecipeUsecase(r);
      await cargarRecetas();
    } catch (e) {
      debugPrint("Error creando: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> actualizarProducto(String id, Recipe r) async {
    setLoading(true);
    try {
      await updateRecipesUseCase(id, r);
      await cargarRecetas();
    } catch (e) {
      debugPrint("Error actualizando: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> eliminarProducto(String id) async {
    setLoading(true);
    try {
      await deleteRecipeUsecase(id);
      await cargarRecetas();
    } catch (e) {
      debugPrint("Error eliminando: $e");
    } finally {
      setLoading(false);
    }
  }
}



