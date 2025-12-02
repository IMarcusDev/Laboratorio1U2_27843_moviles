import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';

class EditRecipeSheet extends StatefulWidget {
  final Recipe? recipe;

  const EditRecipeSheet({super.key, this.recipe});

  @override
  State<EditRecipeSheet> createState() => _EditRecipeSheetState();
}

class _EditRecipeSheetState extends State<EditRecipeSheet> {
  // Controllers principales
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  // Ingredientes dinámicos
  List<Ingredient> _ingredients = [];

  // Pasos dinámicos
  List<String> _steps = [];
  final _stepCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      final r = widget.recipe!;
      _nameCtrl.text = r.name;
      _descriptionCtrl.text = r.description;
      _countryCtrl.text = r.country;
      _ingredients = List.from(r.ingredients);
      _steps = List.from(r.steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<RecipeViewmodel>();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                Text(
                  widget.recipe == null ? "Nueva Receta" : "Editar Receta",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),

                _buildField("Nombre", _nameCtrl),
                _buildField("Descripción", _descriptionCtrl, maxLines: 3),
                _buildField("País", _countryCtrl),

                const SizedBox(height: 20),
                _buildIngredientsSection(),
                const SizedBox(height: 20),
                _buildStepsSection(),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final newRecipe = Recipe(
                        id: widget.recipe?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameCtrl.text,
                        description: _descriptionCtrl.text,
                        country: _countryCtrl.text,
                        ingredients: _ingredients,
                        steps: _steps,
                      );

                      if (widget.recipe == null) {
                        vm.agregarRecetas(newRecipe);
                      } else {
                        vm.actualizarProducto(widget.recipe!.id, newRecipe);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      widget.recipe == null ? "Crear" : "Guardar Cambios",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------------------------

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // INGREDIENTES
  // ---------------------------------------------------------------------------
  Widget _buildIngredientsSection() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ingredientes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        for (int i = 0; i < _ingredients.length; i++)
          Card(
            child: ListTile(
              title: Text("${_ingredients[i].quantity} ${_ingredients[i].unit} - ${_ingredients[i].name}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => _ingredients.removeAt(i));
                },
              ),
            ),
          ),

        const SizedBox(height: 12),

        _buildField("Ingrediente", nameCtrl),
        Row(
          children: [
            Expanded(child: _buildField("Cantidad", qtyCtrl)),
            const SizedBox(width: 12),
            Expanded(child: _buildField("Unidad", unitCtrl)),
          ],
        ),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              if (nameCtrl.text.isEmpty ||
                  qtyCtrl.text.isEmpty ||
                  unitCtrl.text.isEmpty) return;

              setState(() {
                _ingredients.add(
                  Ingredient(
                    name: nameCtrl.text,
                    quantity: int.tryParse(qtyCtrl.text) ?? 0,
                    unit: unitCtrl.text,
                  ),
                );
              });

              nameCtrl.clear();
              qtyCtrl.clear();
              unitCtrl.clear();
            },
            icon: const Icon(Icons.add),
            label: const Text("Agregar ingrediente"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PASOS
  // ---------------------------------------------------------------------------
  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pasos",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        for (int i = 0; i < _steps.length; i++)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text("${i + 1}", style: const TextStyle(color: Colors.white)),
              ),
              title: Text(_steps[i]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _steps.removeAt(i)),
              ),
            ),
          ),

        const SizedBox(height: 12),

        TextField(
          controller: _stepCtrl,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: "Nuevo paso...",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_stepCtrl.text.isEmpty) return;

              setState(() => _steps.add(_stepCtrl.text));
              _stepCtrl.clear();
            },
            icon: const Icon(Icons.add),
            label: const Text("Agregar paso"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
