import 'package:laboratorio1u2_27843_app/src/domain/repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase(this.repository);

  Future<bool> call(String id) => repository.deleteProduct(id);
}