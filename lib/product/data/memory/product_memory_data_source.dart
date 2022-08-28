import '../model/product.dart';

class ProductMemoryDataSource {
  Future<Product> getById(String id) async {
    return Product(
        id: id,
        name: 'Vanilla Sweet Cream Cold Brew',
        description: 'Our slow-stepped custom blend coffee accented with vanilla and topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup.',
      customizations: [
        const ProductCustomization.cupSizes(id: '1', sizes: ['Tall', 'Grande', 'Venti']),
        const ProductCustomization.items(id: '2', name: 'Milk', items: ['Soymilk', 'Normal', 'Almond', 'Integral']),
        const ProductCustomization.items(id: '3', name: 'Toppings', items: ['Vanilla Syrup', 'Chocolate', 'Cream']),
      ],
    );
  }
}
