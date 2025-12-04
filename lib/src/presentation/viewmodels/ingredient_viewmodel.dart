import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/ingredient_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/ingredient_model.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/base_viewmodel.dart';

class IngredientViewModel extends BaseViewModel {
  // Usamos la clase específica que acabamos de crear
  final IngredientApiDatasource _datasource = IngredientApiDatasource();
  
  List<Ingredient> ingredients = [];

  Future<void> loadIngredients() async {
    setLoading(true);
    try {
      // Llamada directa y clara
      ingredients = await _datasource.getIngredients();
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> addIngredient(Ingredient ing) async {
    setLoading(true);
    try {
      // Convertimos la entidad a modelo
      final model = IngredientModel(
        name: ing.name, 
        description: ing.description, 
        calories: ing.calories
      );
      
      await _datasource.createIngredient(model);
      
      // Recargamos la lista para ver el nuevo item
      await loadIngredients();
    } catch (e) {
      debugPrint("Error al agregar");
    } finally {
      setLoading(false);
    }
  }

  Future<void> editIngredient(String id, Ingredient ing) async {
    setLoading(true);
    try {
      final model = IngredientModel(
        name: ing.name, 
        description: ing.description, 
        calories: ing.calories
      );
      
      await _datasource.updateIngredient(id, model);
      
      // Recargamos la lista para ver los cambios reflejados
      await loadIngredients();
    } catch (e) {
      debugPrint("Error al editar");
    } finally {
      setLoading(false);
    }
  }
  
  Future<void> deleteIngredient(String id) async {
    setLoading(true);
    try {
      await _datasource.deleteIngredient(id);
      await loadIngredients();
    } catch(e) {
      debugPrint("Error al eliminar");
    } finally {
      setLoading(false);
    }
  }
}