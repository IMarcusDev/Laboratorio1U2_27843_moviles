import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_products_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/base_viewmodel.dart';

class ProductViewModel extends BaseViewModel {
  final GetProductsUsecase getProductsUsecase;
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  List<Product> products = [];

  ProductViewModel(
    this.getProductsUsecase,
    this.createProductUsecase,
    this.updateProductUsecase,
    this.deleteProductUsecase,
  );

  Future<void> cargarProductos() async {
    setLoading(true);
    try {
      products = await getProductsUsecase();
    } catch (e) {
      print("Error cargando: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> agregarProducto(Product p) async {
    setLoading(true);
    try {
      await createProductUsecase(p);
      await cargarProductos();
    } catch (e) {
      print("Error creando: $e");
      setLoading(false);
    }
  }

  Future<void> actualizarProducto(String id, Product p) async {
    setLoading(true);
    try {
      await updateProductUsecase(id, p);
      await cargarProductos();
    } catch (e) {
      print("Error actualizando: $e");
      setLoading(false);
    }
  }

  Future<void> eliminarProducto(String id) async {
    setLoading(true);
    try {
      await deleteProductUsecase(id);
      await cargarProductos();
    } catch (e) {
      print("Error eliminando: $e");
      setLoading(false);
    }
  }
}