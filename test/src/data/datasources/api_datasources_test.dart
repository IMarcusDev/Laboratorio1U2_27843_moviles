import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/recipe_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/ingredient_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/recipe_model.dart';

void main() {
  group('Data Layer - RecipeApiDatasource', () {
    test('fetchAll returns list on 200', () async {
      final client = MockClient((_) async => http.Response('[{"id":"1","name":"A","description":"B","country":"C","ingredients":[],"steps":[]}]', 200));
      final ds = RecipeApiDatasource(client: client);
      expect((await ds.fetchAll()).length, 1);
    });

    test('fetchAll returns empty on 500', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final ds = RecipeApiDatasource(client: client);
      expect(await ds.fetchAll(), isEmpty);
    });

    test('create returns model on 201', () async {
      final client = MockClient((_) async => http.Response('{"id":"99","name":"A","description":"B","country":"C","ingredients":[],"steps":[]}', 201));
      final ds = RecipeApiDatasource(client: client);
      final result = await ds.create(RecipeModel(id: '', name: 'A', description: 'B', country: 'C', ingredients: [], steps: []).toJson());
      expect(result.id, "99");
    });

    test('delete returns true on 200', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final ds = RecipeApiDatasource(client: client);
      expect(await ds.delete('1'), true);
    });
  });

  group('Data Layer - IngredientApiDatasource', () {
    test('getIngredients returns list on 200', () async {
      final client = MockClient((_) async => http.Response('[{"name":"Sal","quantity":1,"unit":"g"}]', 200));
      final ds = IngredientApiDatasource(client: client);
      expect((await ds.getIngredients()).length, 1);
    });
  });
}