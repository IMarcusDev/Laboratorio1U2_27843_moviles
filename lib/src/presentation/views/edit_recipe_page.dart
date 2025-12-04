import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/ingredient_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/ingredient.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/recipe.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;

  const EditRecipePage({super.key, this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _stepCtrl = TextEditingController();

  final _qtyCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  Ingredient? _selectedIngredient;

  List<Ingredient> _ingredients = [];
  List<String> _steps = [];

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final ingVm = context.read<IngredientViewModel>();
        if (ingVm.ingredients.isEmpty) {
          ingVm.loadIngredients();
        }
      } catch (e) {
        debugPrint("Error loading ingredients: $e");
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _countryCtrl.dispose();
    _stepCtrl.dispose();
    _qtyCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.recipe == null ? "Nueva Receta" : "Editar Receta",
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text("GUARDAR", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Información General"),
              const SizedBox(height: 15),
              _buildTextField("Nombre del plato", _nameCtrl, Icons.restaurant_menu),
              const SizedBox(height: 15),
              _buildTextField("Descripción", _descriptionCtrl, Icons.description, maxLines: 3),
              const SizedBox(height: 15),
              _buildTextField("País de origen", _countryCtrl, Icons.flag),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              _buildIngredientsSection(context),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              // SECCIÓN PASOS
              _buildStepsSection(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey, size: 22),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return Consumer<IngredientViewModel>(
      builder: (context, ingredientVm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle("Ingredientes"),
                if (_ingredients.isNotEmpty)
                  Chip(
                    label: Text("${_ingredients.length}"),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (_ingredients.isEmpty)
              const Text("No hay ingredientes añadidos", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
            else
              Column(
                children: [
                  for (var ing in _ingredients)
                    Card(
                      elevation: 0,
                      color: Colors.grey.shade50,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
                      child: ListTile(
                        dense: true,
                        title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text("${ing.quantity} ${ing.unit}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                          onPressed: () => setState(() => _ingredients.remove(ing)),
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Añadir Ingrediente", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Ingredient>(
                    isExpanded: true,
                    value: _selectedIngredient,
                    hint: const Text("Seleccionar producto..."),
                    decoration: InputDecoration(
                      filled: true, fillColor: const Color(0xFFF8F9FA),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    items: ingredientVm.ingredients.map((ing) {
                      return DropdownMenuItem(value: ing, child: Text(ing.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedIngredient = val),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _qtyCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Cant.",
                            filled: true, fillColor: const Color(0xFFF8F9FA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _unitCtrl,
                          decoration: InputDecoration(
                            hintText: "Unidad",
                            filled: true, fillColor: const Color(0xFFF8F9FA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: _addIngredient,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _addIngredient() {
    if (_selectedIngredient == null || _qtyCtrl.text.isEmpty || _unitCtrl.text.isEmpty) return;
    setState(() {
      _ingredients.add(Ingredient(
        id: _selectedIngredient!.id,
        name: _selectedIngredient!.name,
        description: _selectedIngredient!.description,
        calories: _selectedIngredient!.calories,
        quantity: int.tryParse(_qtyCtrl.text) ?? 0,
        unit: _unitCtrl.text,
      ));
    });
    _qtyCtrl.clear();
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Pasos de preparación"),
        const SizedBox(height: 10),
        
        if (_steps.isNotEmpty)
          ..._steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12, backgroundColor: AppColors.primary,
                  child: Text("${entry.key + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 15))),
                GestureDetector(
                  onTap: () => setState(() => _steps.removeAt(entry.key)),
                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                ),
              ],
            ),
          )),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _stepCtrl,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _addStep(),
                decoration: InputDecoration(
                  hintText: "Escribir paso...",
                  filled: true, fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addStep,
              style: IconButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _addStep() {
    if (_stepCtrl.text.trim().isEmpty) return;
    setState(() => _steps.add(_stepCtrl.text.trim()));
    _stepCtrl.clear();
  }

  void _saveRecipe() {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("El nombre es obligatorio")));
      return;
    }

    final vm = context.read<RecipeViewmodel>();
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
  }
}