import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_products.dart';
import '../../domain/use_cases/search_products.dart';

enum ProductListStatus {
  initial,
  loading,
  success,
  empty,
  failure,
  loadingMore,
  refreshing,
}

class ProductListState extends Equatable {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.total = 0,
    this.hasMore = true,
    this.query = '',
    this.errorMessage,
    this.loadMoreError,
  });

  final ProductListStatus status;
  final List<Product> products;
  final int total;
  final bool hasMore;
  final String query;
  final String? errorMessage;
  final String? loadMoreError;

  bool get isSearching => query.trim().isNotEmpty;

  bool get isInitialLoading =>
      status == ProductListStatus.loading ||
      status == ProductListStatus.initial;

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    int? total,
    bool? hasMore,
    String? query,
    String? errorMessage,
    String? loadMoreError,
    bool clearError = false,
    bool clearLoadMoreError = false,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    total,
    hasMore,
    query,
    errorMessage,
    loadMoreError,
  ];
}

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit({
    required GetProducts getProducts,
    required SearchProducts searchProducts,
  }) : _getProducts = getProducts,
       _searchProducts = searchProducts,
       super(const ProductListState());

  final GetProducts _getProducts;
  final SearchProducts _searchProducts;
  bool _isFetching = false;
  Timer? _debounce;
  int _requestId = 0;

  Future<void> loadInitial() => _fetch(replace: true, showLoading: true);

  Future<void> refresh() => _fetch(replace: true, refreshing: true);

  void onQueryChanged(String value) {
    final query = value.trim();
    emit(state.copyWith(query: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetch(replace: true, showLoading: true);
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    if (!state.isSearching && state.query.isEmpty) return;
    emit(state.copyWith(query: ''));
    _fetch(replace: true, showLoading: true);
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore) return;
    if (state.status == ProductListStatus.loading ||
        state.status == ProductListStatus.failure ||
        state.status == ProductListStatus.empty) {
      return;
    }
    await _fetch(replace: false, loadingMore: true);
  }

  Future<void> _fetch({
    required bool replace,
    bool showLoading = false,
    bool refreshing = false,
    bool loadingMore = false,
  }) async {
    if (_isFetching && !replace) return;
    _isFetching = true;
    final requestId = ++_requestId;
    final query = state.query.trim();

    if (showLoading) {
      emit(
        state.copyWith(
          status: ProductListStatus.loading,
          clearError: true,
          clearLoadMoreError: true,
        ),
      );
    } else if (refreshing) {
      emit(
        state.copyWith(
          status: ProductListStatus.refreshing,
          clearError: true,
          clearLoadMoreError: true,
        ),
      );
    } else if (loadingMore) {
      emit(
        state.copyWith(
          status: ProductListStatus.loadingMore,
          clearLoadMoreError: true,
        ),
      );
    }

    try {
      final page = query.isEmpty
          ? await _getProducts(
              limit: AppConfig.productsPageSize,
              skip: replace ? 0 : state.products.length,
            )
          : await _searchProducts(
              query: query,
              limit: AppConfig.productsPageSize,
              skip: replace ? 0 : state.products.length,
            );

      if (requestId != _requestId) return;
      _emitPage(page, replace: replace);
    } catch (error) {
      if (requestId != _requestId) return;
      if (loadingMore) {
        emit(
          state.copyWith(
            status: ProductListStatus.success,
            loadMoreError: mapExceptionToFailure(error).message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: state.products.isEmpty || replace
                ? ProductListStatus.failure
                : ProductListStatus.success,
            errorMessage: mapExceptionToFailure(error).message,
            products: replace ? const [] : null,
          ),
        );
      }
    } finally {
      if (requestId == _requestId) {
        _isFetching = false;
      }
    }
  }

  void _emitPage(ProductPage page, {required bool replace}) {
    final products = replace
        ? page.products
        : [...state.products, ...page.products];

    if (products.isEmpty) {
      emit(
        state.copyWith(
          status: ProductListStatus.empty,
          products: const [],
          total: page.total,
          hasMore: false,
          clearError: true,
          clearLoadMoreError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ProductListStatus.success,
        products: products,
        total: page.total,
        hasMore: products.length < page.total,
        clearError: true,
        clearLoadMoreError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
