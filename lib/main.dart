import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/data/datasource/recipe_api_datasource.dart';
import 'package:laboratorio1u2_27843_app/src/data/repositories/product_repository_impl.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/create_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/delete_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/get_recipes_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/domain/usecases/update_recipe_usecase.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/routes/app_routes.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_theme.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final dataSource = RecipeApiDatasource();
  final repository = RecipeRepositoryImpl(dataSource);

  final getUsecase = GetRecipesUseCase(repository);
  final createUsecase = CreateRecipeUsecase(repository);
  final updateUsecase = UpdateRecipesUseCase(repository);
  final deleteUsecase = DeleteRecipeUsecase(repository);

  runApp(MyApp(
    getUsecase: getUsecase,
    createUsecase: createUsecase,
    updateUsecase: updateUsecase,
    deleteUsecase: deleteUsecase,
  ));
}

class MyApp extends StatelessWidget {
  final GetRecipesUseCase getUsecase;
  final CreateRecipeUsecase createUsecase;
  final UpdateRecipesUseCase updateUsecase;
  final DeleteRecipeUsecase deleteUsecase;

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
          create: (_) => RecipeViewmodel(
            getUsecase,
            createUsecase,
            updateUsecase,
            deleteUsecase,
          )..cargarRecetas(),
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