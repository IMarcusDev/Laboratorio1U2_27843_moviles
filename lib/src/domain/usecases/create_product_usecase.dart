import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/product_repository.dart';

class CreateProductUsecase {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);

  Future<Product> call(Product product) => repository.createProduct(product);
}