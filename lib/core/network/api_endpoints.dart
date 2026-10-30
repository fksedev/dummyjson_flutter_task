abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String products = '/products';
  static const String searchProducts = '/products/search';

  static String productById(int id) => '/products/$id';
}
