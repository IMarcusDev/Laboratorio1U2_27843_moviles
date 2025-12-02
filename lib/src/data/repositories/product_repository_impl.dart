import 'package:laboratorio1u2_27843_app/src/data/datasource/product_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/models/product_model.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    return await datasource.fetchAll();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      stock: product.stock,
      category: product.category,
    );
    return await datasource.create(productModel.toJson());
  }

  @override
  Future<Product> updateProduct(String id, Product product) async {
    final productModel = ProductModel(
      id: id,
      name: product.name,
      price: product.price,
      stock: product.stock,
      category: product.category,
    );
    return await datasource.update(id, productModel.toJson());
  }

  @override
  Future<bool> deleteProduct(String id) async {
    return await datasource.delete(id);
  }
}