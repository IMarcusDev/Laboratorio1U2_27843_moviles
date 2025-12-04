class Ingredient {
  final String? id; 
  final String name;
  final String? description;
  final int? calories; 
  

  final int quantity; 
  final String unit;

  Ingredient({
    this.id,
    required this.name,
    this.description,
    this.calories,
    this.quantity = 0,
    this.unit = '',
  });
  
  Ingredient copyWithQuantity(int qty, String unt) {
    return Ingredient(
      id: id,
      name: name,
      description: description,
      calories: calories,
      quantity: qty,
      unit: unt,
    );
  }
}