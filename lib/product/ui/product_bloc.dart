import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample_app/product/data/product_repository.dart';

import '../data/product.dart';

part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required this.id,
    required this.productRepository,
  }) : super(const ProductState.loading()) {
    on<LoadProductEvent>(_loadProductById);

    add(ProductEvent.load(id: id));
  }

  final String id;
  final ProductRepository productRepository;

  void _loadProductById(LoadProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    final product = await productRepository.getById(id);
    emit(ProductState.loaded(product: product));
  }
}

// Events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.load({required String id}) = LoadProductEvent;
}

// States
abstract class _ProductState {
  const _ProductState();

  bool get canAddOrder;
}

@freezed
class ProductState with _$ProductState implements _ProductState {
  const ProductState._();

  const factory ProductState.loading() = LoadingProductState;
  const factory ProductState.loaded({required Product product}) = ProductLoadedState;

  @override
  bool get canAddOrder => maybeWhen(loading: () => false, orElse: () => true);
}
