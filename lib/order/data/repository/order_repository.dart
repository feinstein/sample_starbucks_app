import '../memory/order_memory_data_source.dart';
import '../model/order.dart';

class OrderRepository {
  OrderRepository(this.orderMemoryDataSource);

  final OrderMemoryDataSource orderMemoryDataSource;
  final _openOrders = <Order>[];

  void addOrder(Order order) => _openOrders.add(order);

  List<Order> getOpenOrders() => [..._openOrders];

  Future<void> finishOpenOrders(Order order) async {
    try {
      await orderMemoryDataSource.sendOrders(_openOrders);
      _openOrders.clear();
    } catch (e, s) {
      // TODO: Proper error handling?
      print(e);
    }
  }
}
