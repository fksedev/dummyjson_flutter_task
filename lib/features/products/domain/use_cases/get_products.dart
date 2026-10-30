import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  GetProducts(this._repository);

  final ProductRepository _repository;

  Future<ProductPage> call({required int limit, required int skip}) {
    return _repository.getProducts(limit: limit, skip: skip);
  }
}
