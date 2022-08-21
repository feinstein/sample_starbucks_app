import 'product.dart';

class ProductMemoryDataSource {
  Product getById(String id) {
    return Product(
        id: id,
        name: 'Vanilla Sweet Cream Cold Brew',
        description: 'Our slow-stepped custom blend coffee accented with vanilla and topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup.',
    );
  }
}
