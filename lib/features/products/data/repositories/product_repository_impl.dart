import '../../../../core/errors/exception_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/product_remote_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteService);

  final ProductRemoteService _remoteService;

  @override
  Future<ProductPage> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final dto = await _remoteService.getProducts(limit: limit, skip: skip);
      return dto.toEntity();
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }

  @override
  Future<ProductPage> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final dto = await _remoteService.searchProducts(
        query: query,
        limit: limit,
        skip: skip,
      );
      return dto.toEntity();
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final dto = await _remoteService.getProductById(id);
      return dto.toEntity();
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }
}
