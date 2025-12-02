abstract class BaseDatasource<T> {
  Future<List<T>> fetchAll();
  Future<T> create(Map<String, dynamic> data);
  Future<T> update(String id, Map<String, dynamic> data);
  Future<bool> delete(String id);
}