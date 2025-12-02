import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository repository;
  UpdateProductUsecase(this.repository);

  Future<Product> call(String id, Product product) => repository.updateProduct(id, product);
}