import 'package:decimal/decimal.dart';

import '../model/product.dart';

class ProductMemoryDataSource {
  Future<Product> getById(String id) async {
    return Product(
      id: id,
      name: 'Vanilla Sweet Cream Cold Brew',
      description: 'Our slow-stepped custom blend coffee accented with vanilla and topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup.',
      customizations: [
        ProductCustomization.cupSizes(id: '1a', sizes: [
          ProductCustomizationItem(id: '1', name: 'Tall', price: Decimal.parse('3.20')),
          ProductCustomizationItem(id: '2', name: 'Grande', price: Decimal.parse('4.50')),
          ProductCustomizationItem(id: '3', name: 'Venti', price: Decimal.parse('5.15')),
        ]),
        ProductCustomization.items(id: '2a', name: 'Milk', items: [
          ProductCustomizationItem(id: '4', name: 'Soymilk', price: Decimal.parse('0.30')),
          ProductCustomizationItem(id: '5', name: 'Normal', price: Decimal.parse('0.0')),
          ProductCustomizationItem(id: '6', name: 'Almond', price: Decimal.parse('0.43')),
          ProductCustomizationItem(id: '7', name: 'Integral', price: Decimal.parse('0.21')),
        ]),
        ProductCustomization.items(id: '3a', name: 'Toppings', items: [
          ProductCustomizationItem(id: '8', name: 'Vanilla Syrup', price: Decimal.parse('0.20')),
          ProductCustomizationItem(id: '9', name: 'Chocolate', price: Decimal.parse('0.33')),
          ProductCustomizationItem(id: '10', name: 'Cream', price: Decimal.parse('0.40')),
        ]),
      ],
    );
  }
}
