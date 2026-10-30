import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  GetProductById(this._repository);

  final ProductRepository _repository;

  Future<Product> call(int id) => _repository.getProductById(id);
}
