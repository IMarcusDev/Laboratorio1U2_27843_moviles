import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(String id, Product product);
  Future<bool> deleteProduct(String id);
}