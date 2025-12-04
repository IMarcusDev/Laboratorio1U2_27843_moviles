import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

// Tema y Estilos
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';

// ViewModel
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';

// Vistas y Widgets
import 'package:laboratorio1u2_27843_app/src/presentation/views/edit_recipe_page.dart'; // Importamos la nueva página
import 'package:laboratorio1u2_27843_app/src/presentation/widgets/recipe_card.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/widgets/loading_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecipeViewmodel>();

    return Scaffold(
      // Botón flotante para CREAR
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // CAMBIO CLAVE: Navegamos a la página completa en lugar de abrir un modal
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditRecipePage()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Nuevo", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      
      body: RefreshIndicator(
        onRefresh: vm.cargarRecetas,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // AppBar Deslizante
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Recetario',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => setState(() => _isGrid = !_isGrid),
                  icon: Icon(_isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded),
                  tooltip: _isGrid ? 'Ver como lista' : 'Ver como grid',
                ),
              ],
            ),

            // Estado de Carga Inicial
            if (vm.loading)
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: LoadingShimmer(isGrid: _isGrid),
                ),
              )
            
            // Estado Vacío
            else if (vm.visibleRecipes.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              )
            
            // Lista de Recetas
            else
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: _isGrid ? _buildGrid(vm) : _buildList(vm),
              ),
          ],
        ),
      ),
    );
  }

  // Construye la vista de Lista
  Widget _buildList(RecipeViewmodel vm) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Paginación
          if (index == vm.visibleRecipes.length - 1 && vm.hasMore && !vm.isLoadingMore) {
            vm.cargarMas();
          }

          // Loader al final de la lista
          if (index == vm.visibleRecipes.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final recipe = vm.visibleRecipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecipeCard(
              recipe: recipe,
              onTap: () => _showOptions(context, vm, recipe.id, recipe),
            ),
          );
        },
        childCount: vm.visibleRecipes.length + (vm.hasMore ? 1 : 0),
      ),
    );
  }

  // Construye la vista de Grid (Cuadrícula)
  Widget _buildGrid(RecipeViewmodel vm) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Paginación
          if (index == vm.visibleRecipes.length - 1 && vm.hasMore && !vm.isLoadingMore) {
            vm.cargarMas();
          }

          // Loader al final
          if (index == vm.visibleRecipes.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final recipe = vm.visibleRecipes[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () => _showOptions(context, vm, recipe.id, recipe),
          );
        },
        childCount: vm.visibleRecipes.length + (vm.hasMore ? 1 : 0),
      ),
    );
  }

  // Pantalla cuando no hay datos
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 180,
          child: Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_j1adxtyb.json',
            fit: BoxFit.contain,
            repeat: true,
            // Fallback por si no carga Lottie
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.menu_book_rounded, size: 80, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "No hay recetas aún",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        const Text(
          "Presiona + para agregar tu primera receta",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Menú de opciones (Editar / Eliminar)
  void _showOptions(BuildContext context, RecipeViewmodel vm, String id, dynamic recipe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barrita gris superior
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            
            // Opción EDITAR
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.edit_rounded, color: Colors.blue),
              ),
              title: const Text("Editar Receta",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(ctx); // Cerramos el menú de opciones primero
                
                // CAMBIO CLAVE: Navegamos a la página de edición
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditRecipePage(recipe: recipe)),
                );
              },
            ),
            const SizedBox(height: 8),
            
            // Opción ELIMINAR
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.delete_rounded, color: Colors.red),
              ),
              title: const Text("Eliminar Receta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                vm.eliminarProducto(id);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}