import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String productId,
    required List<OrderProductCustomization> customizations,
  }) = _Order;

  const Order._();

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}

@freezed
class OrderProductCustomization with _$OrderProductCustomization {
  const factory OrderProductCustomization({
    required String id,
    required String value,
  }) = _OrderProductCustomization;

  const OrderProductCustomization._();

  factory OrderProductCustomization.fromJson(Map<String, Object?> json) => _$OrderProductCustomizationFromJson(json);
}
