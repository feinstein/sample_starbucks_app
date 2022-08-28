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

abstract class _ProductCustomization {
  const _ProductCustomization({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  Map<String, Object?> toJson();
}

@freezed
class ProductCustomization with _$ProductCustomization implements _ProductCustomization {
  const ProductCustomization._();

  const factory ProductCustomization({
    required String id,
    required String name,
    required String? description,
  }) = _ProductCustomizationGeneric;

  const factory ProductCustomization.items({
    required String id,
    required String name,
    String? description,
    required List<String> items,
  }) = _ProductCustomizationItems;

  const factory ProductCustomization.cupSizes({
    required String id,
    String? description,
    required List<String> sizes,
  }) = _ProductCustomizationCupSizes;

  @override
  String get name => map((generic) => generic.name, items: (items) => items.name, cupSizes: (cupSizes) => 'cupSizes');

  factory ProductCustomization.fromJson(Map<String, Object?> json) => const _ProductCustomizationConverter().fromJson(json);
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
      return _ProductCustomizationGeneric.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson(_ProductCustomization data) => data.toJson();
}
