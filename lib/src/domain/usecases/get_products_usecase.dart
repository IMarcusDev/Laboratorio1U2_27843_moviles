import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/domain/repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repository;
  GetProductsUsecase(this.repository);

  Future<List<Product>> call() => repository.getProducts();
}