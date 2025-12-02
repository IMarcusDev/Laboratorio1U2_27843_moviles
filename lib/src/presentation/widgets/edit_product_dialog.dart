import 'package:flutter/material.dart';
import 'package:laboratorio1u2_27843_app/src/domain/entities/product.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/theme/app_colors.dart';
import 'package:laboratorio1u2_27843_app/src/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';


class EditProductSheet extends StatefulWidget {
  final Product? product;

  const EditProductSheet({super.key, this.product});

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController stockCtrl;
  late TextEditingController categoryCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    nameCtrl = TextEditingController(text: p?.name ?? '');
    priceCtrl = TextEditingController(text: p?.price.toString() ?? '');
    stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');
    categoryCtrl = TextEditingController(text: p?.category ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProductViewModel>();
    final isEditing = widget.product != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, 
                  height: 4, 
                  decoration: BoxDecoration(
                    color: AppColors.border, 
                    borderRadius: BorderRadius.circular(2)
                  )
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                isEditing ? 'Editar Producto' : 'Crear Producto',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              _buildInput(nameCtrl, 'Nombre del producto', Icons.tag),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInput(priceCtrl, 'Precio', Icons.attach_money, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInput(stockCtrl, 'Stock', Icons.inventory, isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInput(categoryCtrl, 'Categoría', Icons.category_outlined),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newProduct = Product(
                        id: isEditing ? widget.product!.id : '',
                        name: nameCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        stock: int.tryParse(stockCtrl.text) ?? 0,
                        category: categoryCtrl.text,
                      );

                      if (isEditing) {
                        vm.actualizarProducto(newProduct.id, newProduct);
                      } else {
                        vm.agregarProducto(newProduct);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? "Guardar Cambios" : "Crear Ahora"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (v) => v!.isEmpty ? 'Requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}