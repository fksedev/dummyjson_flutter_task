import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_dto.dart';

class ProductRemoteService {
  ProductRemoteService(this._apiClient);

  final ApiClient _apiClient;

  Future<ProductPageDto> getProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty products response');
    }
    return ProductPageDto.fromJson(data);
  }

  Future<ProductPageDto> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.searchProducts,
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty search response');
    }
    return ProductPageDto.fromJson(data);
  }

  Future<ProductDto> getProductById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.productById(id),
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty product response');
    }
    return ProductDto.fromJson(data);
  }
}
