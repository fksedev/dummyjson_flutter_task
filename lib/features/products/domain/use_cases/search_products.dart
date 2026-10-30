import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  SearchProducts(this._repository);

  final ProductRepository _repository;

  Future<ProductPage> call({
    required String query,
    required int limit,
    required int skip,
  }) {
    return _repository.searchProducts(query: query, limit: limit, skip: skip);
  }
}
