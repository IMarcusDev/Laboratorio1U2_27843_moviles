import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/recipe_viewmodel.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/ingredient_viewmodel.dart';

// Entidades y Tema
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
  // Controladores de texto
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _stepCtrl = TextEditingController();
  
  // Controladores para ingredientes
  final _qtyCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  Ingredient? _selectedIngredient;

  // Listas de datos
  List<Ingredient> _ingredients = [];
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales si es edición
    if (widget.recipe != null) {
      final r = widget.recipe!;
      _nameCtrl.text = r.name;
      _descCtrl.text = r.description;
      _countryCtrl.text = r.country;
      _ingredients = List.from(r.ingredients);
      _steps = List.from(r.steps);
    }

    // Cargar ingredientes del ViewModel de forma segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final ingVm = context.read<IngredientViewModel>();
        if (ingVm.ingredients.isEmpty) {
          ingVm.loadIngredients();
        }
      } catch (e) {
        debugPrint("Error cargando ingredientes: $e");
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _countryCtrl.dispose();
    _stepCtrl.dispose();
    _qtyCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos el espacio del teclado
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      // Diseño de hoja de altura completa
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------------------------------------------------
          // 1. ENCABEZADO FIJO (No se mueve con el teclado)
          // ---------------------------------------------------------
          _buildHeader(context),

          // ---------------------------------------------------------
          // 2. CUERPO DESPLAZABLE (El formulario)
          // ---------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle("Información Básica"),
                  const SizedBox(height: 15),
                  _buildTextField(label: "Nombre del plato", controller: _nameCtrl, icon: Icons.restaurant_menu),
                  const SizedBox(height: 15),
                  _buildTextField(label: "Descripción", controller: _descCtrl, maxLines: 3, icon: Icons.description_outlined),
                  const SizedBox(height: 15),
                  _buildTextField(label: "País de origen", controller: _countryCtrl, icon: Icons.flag_outlined),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 20),

                  // TU SELECTOR DE PRODUCTOS (Mantenido)
                  _buildIngredientsSelector(context),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 20),

                  // SECCIÓN DE PASOS
                  _buildStepsSelector(),
                  
                  // Espacio final para que el último elemento no quede oculto por el teclado
                  SizedBox(height: keyboardPadding + 80), 
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 3. BOTÓN FLOTANTE FIJO (Siempre visible sobre el teclado)
          // ---------------------------------------------------------
          _buildBottomActionButton(context, keyboardPadding),
        ],
      ),
    );
  }

  // --- WIDGETS DE DISEÑO ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          Text(
            widget.recipe == null ? "Nueva Receta" : "Editar Receta",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 60), // Espacio para equilibrar el botón de cancelar
        ],
      ),
    );
  }

  Widget _buildBottomActionButton(BuildContext context, double keyboardPadding) {
    // Si el teclado está abierto, ocultamos este botón inferior para dar más espacio visual,
    // o lo dejamos pegado al teclado. Aquí lo dejamos fijo abajo para estabilidad.
    if (keyboardPadding > 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: _saveRecipe,
          child: Text(
            widget.recipe == null ? "CREAR RECETA" : "GUARDAR CAMBIOS",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  // --- LÓGICA DE INGREDIENTES (Tu Dropdown) ---

  Widget _buildIngredientsSelector(BuildContext context) {
    return Consumer<IngredientViewModel>(
      builder: (context, ingredientVm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle("Ingredientes"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text("${_ingredients.length} items", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Lista de items agregados
            if (_ingredients.isNotEmpty)
              ..._ingredients.map((ing) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("${ing.quantity} ${ing.unit}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                      onPressed: () => setState(() => _ingredients.remove(ing)),
                    ),
                  ),
                ),
              )),

            const SizedBox(height: 15),
            
            // Selector y Inputs (Diseño limpio)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<Ingredient>(
                    isExpanded: true,
                    value: _selectedIngredient,
                    hint: const Text("Selecciona un producto"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                            hintText: "Cantidad",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _unitCtrl,
                          decoration: InputDecoration(
                            hintText: "Unidad",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addIngredient,
                      ),
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
    // No limpiamos la unidad por si agregan varios items similares
  }

  // --- LÓGICA DE PASOS ---

  Widget _buildStepsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Pasos de preparación"),
        const SizedBox(height: 15),
        
        if (_steps.isNotEmpty)
          ..._steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Text("${entry.key + 1}", style: const TextStyle(fontSize: 12, color: Colors.white))),
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
                  hintText: "Escribe el siguiente paso...",
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
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

  // --- GUARDADO ---

  void _saveRecipe() {
    if (_nameCtrl.text.isEmpty) return;

    final vm = context.read<RecipeViewmodel>();
    final newRecipe = Recipe(
      id: widget.recipe?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text,
      description: _descCtrl.text,
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