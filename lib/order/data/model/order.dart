import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  factory Order({
    required String productId,
    required List<OrderProductCustomization> customizations,
    required int quantity,
  }) = _Order;

  Order._();

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);

  late final double totalPrice = customizations.fold<double>(0.0, (previousValue, customization) => previousValue + customization.price);
}

@freezed
class OrderProductCustomization with _$OrderProductCustomization {
  const factory OrderProductCustomization({
    required String productId,
    required String customizationId,
    required String customizationItemId,
    required String name,
    required double price,
  }) = _OrderProductCustomization;

  const OrderProductCustomization._();

  factory OrderProductCustomization.fromJson(Map<String, Object?> json) => _$OrderProductCustomizationFromJson(json);
}
