import '../entities/product.dart';

abstract class ProductRepository {
  Future<ProductPage> getProducts({required int limit, required int skip});

  Future<ProductPage> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });

  Future<Product> getProductById(int id);
}
