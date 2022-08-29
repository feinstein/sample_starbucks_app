import '../model/product.dart';

class ProductMemoryDataSource {
  Future<Product> getById(String id) async {
    return Product(
      id: id,
      name: 'Vanilla Sweet Cream Cold Brew',
      description: 'Our slow-stepped custom blend coffee accented with vanilla and topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup.',
      customizations: [
        const ProductCustomization.cupSizes(id: '1a', sizes: [
          ProductCustomizationItem(id: '1', name: 'Tall', price: 3.20),
          ProductCustomizationItem(id: '2', name: 'Grande', price: 4.50),
          ProductCustomizationItem(id: '3', name: 'Venti', price: 5.15),
        ]),
        const ProductCustomization.items(id: '2a', name: 'Milk', items: [
          ProductCustomizationItem(id: '4', name: 'Soymilk', price: 0.30),
          ProductCustomizationItem(id: '5', name: 'Normal', price: 0.0),
          ProductCustomizationItem(id: '6', name: 'Almond', price: 0.43),
          ProductCustomizationItem(id: '7', name: 'Integral', price: 0.21),
        ]),
        const ProductCustomization.items(id: '3a', name: 'Toppings', items: [
          ProductCustomizationItem(id: '8', name: 'Vanilla Syrup', price: 0.20),
          ProductCustomizationItem(id: '9', name: 'Chocolate', price: 0.33),
          ProductCustomizationItem(id: '10', name: 'Cream', price: 0.40),
        ]),
      ],
    );
  }
}
