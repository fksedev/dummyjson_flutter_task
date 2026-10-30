import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exception_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_product_by_id.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.productId,
    this.product,
    this.errorMessage,
  });

  final ProductDetailStatus status;
  final int? productId;
  final Product? product;
  final String? errorMessage;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    int? productId,
    Product? product,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, productId, product, errorMessage];
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._getProductById) : super(const ProductDetailState());

  final GetProductById _getProductById;

  Future<void> load(int id, {Product? seed}) async {
    if (seed != null) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          productId: id,
          product: seed,
          clearError: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProductDetailStatus.loading,
          productId: id,
          clearError: true,
        ),
      );
    }

    try {
      final product = await _getProductById(id);
      emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          productId: id,
          product: product,
          clearError: true,
        ),
      );
    } catch (error) {
      if (state.product != null) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.success,
            productId: id,
            errorMessage: mapExceptionToFailure(error).message,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          productId: id,
          errorMessage: mapExceptionToFailure(error).message,
        ),
      );
    }
  }

  Future<void> retry() async {
    final id = state.productId;
    if (id == null) return;
    await load(id);
  }
}
