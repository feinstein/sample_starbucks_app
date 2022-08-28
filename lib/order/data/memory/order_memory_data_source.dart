import '../model/order.dart';

class OrderMemoryDataSource {
  Future<void> sendOrder(Order order) => Future.delayed(const Duration(seconds: 1));

  Future<void> sendOrders(List<Order> orders) => Future.delayed(const Duration(seconds: 1));
}
