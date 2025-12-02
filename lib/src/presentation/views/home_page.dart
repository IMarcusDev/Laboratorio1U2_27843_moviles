import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/widgets/edit_recipe_sheet.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecipeViewmodel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const EditRecipeSheet(),
        ),
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
            const SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Recetario',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            // Loader inicial
            if (vm.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )

            // Lista vacía
            else if (vm.visibleRecipes.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              )

            // GRID + Scroll infinito
            else
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == vm.visibleRecipes.length - 1 &&
                          vm.hasMore &&
                          !vm.isLoadingMore) {
                        vm.cargarMas();
                      }

                      // Mostrar loading al final (scroll infinito)
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
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_rounded, size: 80, color: AppColors.border),
        const SizedBox(height: 16),
        const Text(
          "No hay productos",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _showOptions(
      BuildContext context, RecipeViewmodel vm, String id, dynamic recipe) {
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
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
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
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => EditRecipeSheet(recipe: recipe),
                );
              },
            ),
            const SizedBox(height: 8),
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
