import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample_app/product/data/product_repository.dart';

import '../data/product.dart';

part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.productRepository) : super (const ProductState._loading()) {
    on<LoadProductEvent>(_loadProductById);
  }

  final ProductRepository productRepository;

  void _loadProductById(LoadProductEvent event, Emitter<ProductState> emit) {

  }
}

// Events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.load({required String id}) = LoadProductEvent;
}

// States
abstract class _ProductState {
  const _ProductState({required this.canAddOrder});

  final bool canAddOrder;
}

@freezed
class ProductState extends _ProductState with _$ProductState {
  const factory ProductState.loading({@Default(false) bool canAddOrder}) = LoadingProductState;
  const factory ProductState.loaded({required Product product, @Default(true) bool canAddOrder}) = ProductLoadedState;
}
