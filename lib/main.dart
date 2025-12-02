import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/product_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/repositories/product_repository_impl.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_products_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_product_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/routes/app_routes.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';



void main() {
  final dataSource = ProductApiDatasource();
  final repository = ProductRepositoryImpl(dataSource);

  final getUsecase = GetProductsUsecase(repository);
  final createUsecase = CreateProductUsecase(repository);
  final updateUsecase = UpdateProductUsecase(repository);
  final deleteUsecase = DeleteProductUsecase(repository);

  runApp(MyApp(
    getUsecase: getUsecase,
    createUsecase: createUsecase,
    updateUsecase: updateUsecase,
    deleteUsecase: deleteUsecase,
  ));
}

class MyApp extends StatelessWidget {
  final GetProductsUsecase getUsecase;
  final CreateProductUsecase createUsecase;
  final UpdateProductUsecase updateUsecase;
  final DeleteProductUsecase deleteUsecase;

  const MyApp({
    super.key,
    required this.getUsecase,
    required this.createUsecase,
    required this.updateUsecase,
    required this.deleteUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(
            getUsecase,
            createUsecase,
            updateUsecase,
            deleteUsecase,
          )..cargarProductos(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Consumo API',
        theme: AppTheme.light,
        routes: AppRoutes.routes,
      ),
    );
  }
}