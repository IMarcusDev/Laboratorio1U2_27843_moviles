import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/recipe_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/ingredient_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/ingredient_model.dart';

void main() {
  final tRecipe = RecipeModel(id: '1', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []);
  final tIngredient = IngredientModel(name: 'S', quantity: 1, unit: 'u');

  // --- RECETAS ---
  group('RecipeApiDatasource', () {
    test('fetchAll 200 OK', () async {
      final client = MockClient((_) async => http.Response('[{"id":"1","name":"A","description":"B","country":"C","ingredients":[],"steps":[]}]', 200));
      final ds = RecipeApiDatasource(client: client);
      expect((await ds.fetchAll()).length, 1);
    });

    test('fetchAll 500 Error (Returns empty)', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = RecipeApiDatasource(client: client);
      expect(await ds.fetchAll(), isEmpty);
    });

    test('create 201 Created', () async {
      final client = MockClient((_) async => http.Response('{"id":"99","name":"A","description":"B","country":"C","ingredients":[],"steps":[]}', 201));
      final ds = RecipeApiDatasource(client: client);
      expect((await ds.create(tRecipe.toJson())).id, "99");
    });

    test('create 400 Bad Request (Throws Exception)', () async {
      final client = MockClient((_) async => http.Response('Error', 400));
      final ds = RecipeApiDatasource(client: client);
      expect(() => ds.create(tRecipe.toJson()), throwsException);
    });

    test('update 200 OK', () async {
      final client = MockClient((_) async => http.Response('{"id":"1","name":"Upd","description":"B","country":"C","ingredients":[],"steps":[]}', 200));
      final ds = RecipeApiDatasource(client: client);
      expect((await ds.update('1', tRecipe.toJson())).name, "Upd");
    });

    test('delete 200 OK', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final ds = RecipeApiDatasource(client: client);
      expect(await ds.delete('1'), true);
    });

    test('delete 500 Error (Returns false)', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = RecipeApiDatasource(client: client);
      expect(await ds.delete('1'), false);
    });
  });

  // --- INGREDIENTES ---
  group('IngredientApiDatasource', () {
    test('getIngredients 200 OK', () async {
      final client = MockClient((_) async => http.Response('[{"name":"Sal","quantity":1,"unit":"g"}]', 200));
      final ds = IngredientApiDatasource(client: client);
      expect((await ds.getIngredients()).length, 1);
    });

    test('getIngredients 500 Error', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.getIngredients(), isEmpty);
    });

    test('createIngredient 201 OK', () async {
      final client = MockClient((_) async => http.Response('{}', 201));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.createIngredient(tIngredient), true);
    });

    test('createIngredient 400 Error', () async {
      final client = MockClient((_) async => http.Response('Error', 400));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.createIngredient(tIngredient), false);
    });

    test('updateIngredient 200 OK', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.updateIngredient('1', tIngredient), true);
    });

    test('updateIngredient 500 Error', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.updateIngredient('1', tIngredient), false);
    });

    test('deleteIngredient 200 OK', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.deleteIngredient('1'), true);
    });

    test('deleteIngredient 500 Error', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = IngredientApiDatasource(client: client);
      expect(await ds.deleteIngredient('1'), false);
    });
  });
}