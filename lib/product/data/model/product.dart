import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    @Default([]) List<ProductCustomization> customizations,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}

@freezed
class ProductCustomization with _$ProductCustomization {
  const factory ProductCustomization.items({
    required String id,
    required String name,
    String? description,
    required List<ProductCustomizationItem> items,
  }) = _ProductCustomizationItems;

  const factory ProductCustomization.cupSizes({
    required String id,
    String? description,
    required List<ProductCustomizationItem> sizes,
  }) = _ProductCustomizationCupSizes;

  const ProductCustomization._();

  String get name => map(items: (items) => items.name, cupSizes: (cupSizes) => 'cupSizes');

  factory ProductCustomization.fromJson(Map<String, Object?> json) => const _ProductCustomizationConverter().fromJson(json);
}

@freezed
class ProductCustomizationItem with _$ProductCustomizationItem {
  const ProductCustomizationItem._();

  const factory ProductCustomizationItem({
    required String id,
    required String name,
    required Decimal price,
  }) = _ProductCustomizationItem;

  factory ProductCustomizationItem.fromJson(Map<String, Object?> json) => _$ProductCustomizationItemFromJson(json);
}

class _ProductCustomizationConverter implements JsonConverter<ProductCustomization, Map<String, Object?>> {
  const _ProductCustomizationConverter();

  @override
  ProductCustomization fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['runtimeType'] != null) {
      return ProductCustomization.fromJson(json);
    }

    if (json['type'] == 'items') {
      return _ProductCustomizationItems.fromJson(json);
    } else if (json['type'] == 'cup_sizes') {
      return _ProductCustomizationCupSizes.fromJson(json);
    } else {
      throw ArgumentError('The json provided can not be mapped to a ProductCustomization');
    }
  }

  @override
  Map<String, dynamic> toJson(ProductCustomization data) => data.toJson();
}
