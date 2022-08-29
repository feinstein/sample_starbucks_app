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
    on<OrderQuantityDecrementEvent>(_orderQuantityDecrement);
    on<OrderQuantityIncrementEvent>(_orderQuantityIncrement);

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
      quantity: 1,
      customizations: product.customizations.map(
        (productCustomization) {
          final customizationItemId = productCustomization.map(
            items: (items) => items.items.first.id,
            cupSizes: (cupSizes) => cupSizes.sizes.first.id,
          );

          final name = productCustomization.map(
            items: (items) => items.items.first.name,
            cupSizes: (cupSizes) => cupSizes.sizes.first.name,
          );

          final price = productCustomization.map(
            items: (items) => items.items.first.price,
            cupSizes: (cupSizes) => cupSizes.sizes.first.price,
          );

          return OrderProductCustomization(
            productId: product.id,
            customizationId: productCustomization.id,
            customizationItemId: customizationItemId,
            name: name,
            price: price,
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

    final currentOrder = state.order;

    final newOrder = currentOrder.copyWith(
        customizations: currentOrder.customizations.map((orderCustomization) {

      if (orderCustomization.customizationId == event.productCustomizationId) {
        final productCustomization = state.product.customizations.firstWhere((productCustomization) => productCustomization.id == event.productCustomizationId);
        final productCustomizationItem = productCustomization.when(
          items: (id, name, description, items) => items.firstWhere((item) => item.id == event.newCustomizationItemId),
          cupSizes: (id, description, sizes) => sizes.firstWhere((size) => size.id == event.newCustomizationItemId),
        );

        return OrderProductCustomization(
          productId: orderCustomization.productId,
          customizationId: event.productCustomizationId,
          customizationItemId: event.newCustomizationItemId,
          name: productCustomizationItem.name,
          price: productCustomizationItem.price,
        );
      }

      return orderCustomization;
    }).toList());

    emit(ProductState(product: state.product, order: newOrder));
  }

  void _orderQuantityDecrement(OrderQuantityDecrementEvent event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is! DefaultProductState) {
      return;
    }

    int currentQuantity = state.order.quantity;
    if (currentQuantity - 1 > 0) {
      final newOrder = state.order.copyWith(quantity: currentQuantity - 1);
      emit(ProductState(product: state.product, order: newOrder));
    }
  }

  void _orderQuantityIncrement(OrderQuantityIncrementEvent event, Emitter<ProductState> emit) async {
    final state = this.state;
    if (state is! DefaultProductState) {
      return;
    }

    int currentQuantity = state.order.quantity;
    final newOrder = state.order.copyWith(quantity: currentQuantity + 1);
    emit(ProductState(product: state.product, order: newOrder));
  }
}

// Events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.load({required String id}) = LoadProductEvent;

  const factory ProductEvent.customizationChanged({
    required String productCustomizationId,
    required String newCustomizationItemId,
  }) = ProductCustomizationChangeEvent;

  const factory ProductEvent.orderQuantityDecrement() = OrderQuantityDecrementEvent;
  const factory ProductEvent.orderQuantityIncrement() = OrderQuantityIncrementEvent;
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
