import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample_app/product/data/repository/product_repository.dart';

import '../../order/data/model/order.dart';
import '../../order/data/repository/order_repository.dart';
import '../data/model/product.dart';

part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required this.id,
    required this.productRepository,
    required this.orderRepository,
  }) : super(const ProductState.loading()) {
    on<LoadProductEvent>(_loadProductById);
    on<ProductCustomizationChangeEvent>(_productCustomizationChanged);

    add(ProductEvent.load(id: id));
  }

  final String id;
  final ProductRepository productRepository;
  final OrderRepository orderRepository;

  void _loadProductById(LoadProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());

    final product = await productRepository.getById(id);
    final order = Order(
      productId: product.id,
      customizations: product.customizations.map(
        (customization) {
          return OrderProductCustomization(
            id: customization.id,
            value: customization.map(
              (value) => value.name,
              items: (items) => items.items.first,
              cupSizes: (cupSizes) => cupSizes.sizes.first,
            ),
          );
        },
      ).toList(),
    );

    emit(ProductState(product: product, order: order));
  }

  void _productCustomizationChanged(ProductCustomizationChangeEvent event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is! DefaultProductState) {
      return;
    }

    final newOrder = state.order.copyWith(
        customizations: state.order.customizations.map((customization) {
      if (customization.id == event.customizationId) {
        return customization.copyWith(value: event.newCustomizationValue);
      }

      return customization;
    }).toList());

    emit(ProductState(product: state.product, order: newOrder));
  }
}

// Events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.load({required String id}) = LoadProductEvent;

  const factory ProductEvent.customizationChanged({
    required String customizationId,
    required String newCustomizationValue,
  }) = ProductCustomizationChangeEvent;
}

// States
abstract class _ProductState {
  const _ProductState();

  bool get canAddOrder;
}

@freezed
class ProductState with _$ProductState implements _ProductState {
  const ProductState._();

  const factory ProductState({required Product product, required Order order}) = DefaultProductState;

  const factory ProductState.loading() = LoadingProductState;

  @override
  bool get canAddOrder => maybeWhen(null, loading: () => false, orElse: () => true);
}
