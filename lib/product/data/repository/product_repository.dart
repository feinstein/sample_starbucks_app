import '../model/product.dart';
import '../memory/product_memory_data_source.dart';

class ProductRepository {
  const ProductRepository(this.memoryDataSource);

  final ProductMemoryDataSource memoryDataSource;

  Future<Product> getById(String id) => memoryDataSource.getById(id);
}
