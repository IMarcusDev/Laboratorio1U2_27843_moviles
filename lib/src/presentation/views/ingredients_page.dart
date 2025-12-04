import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/ingredient_viewmodel.dart';
import 'package:provider/provider.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<IngredientViewModel>().loadIngredients());
  }


  void _showIngredientDialog({Ingredient? ingredientToEdit}) {
    final isEditing = ingredientToEdit != null;
    final nameCtrl = TextEditingController(text: ingredientToEdit?.name ?? '');
    final descCtrl = TextEditingController(text: ingredientToEdit?.description ?? '');
    final calCtrl = TextEditingController(text: ingredientToEdit?.calories?.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? "Editar Ingrediente" : "Nuevo Ingrediente"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nombre (ej. Arroz)")),
              const SizedBox(height: 10),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Descripción")),
              const SizedBox(height: 10),
              TextField(controller: calCtrl, decoration: const InputDecoration(labelText: "Calorías (kcal/100g)"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;

              final ing = Ingredient(
                name: nameCtrl.text,
                description: descCtrl.text,
                calories: int.tryParse(calCtrl.text),
              );

              if (isEditing) {
                context.read<IngredientViewModel>().editIngredient(ingredientToEdit.id!, ing);
              } else {
                context.read<IngredientViewModel>().addIngredient(ing);
              }
              Navigator.pop(ctx);
            },
            child: Text(isEditing ? "Actualizar" : "Guardar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IngredientViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alacena (Ingredientes)", style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showIngredientDialog(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: vm.loading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.ingredients.length,
            itemBuilder: (context, index) {
              final ing = vm.ingredients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.2),
                    child: const Icon(Icons.eco, color: AppColors.accent),
                  ),
                  title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${ing.description ?? ''}\n${ing.calories ?? 0} kcal"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                        onPressed: () => _showIngredientDialog(ingredientToEdit: ing),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => vm.deleteIngredient(ing.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}