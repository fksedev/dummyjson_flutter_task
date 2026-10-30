import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_remote_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/check_session.dart';
import '../../features/auth/domain/use_cases/get_current_user.dart';
import '../../features/auth/domain/use_cases/login.dart';
import '../../features/auth/domain/use_cases/logout.dart';
import '../../features/auth/domain/use_cases/refresh_session.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/data/services/product_remote_service.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/use_cases/get_product_by_id.dart';
import '../../features/products/domain/use_cases/get_products.dart';
import '../../features/products/domain/use_cases/search_products.dart';
import '../../features/products/presentation/cubit/product_detail_cubit.dart';
import '../../features/products/presentation/cubit/product_list_cubit.dart';
import '../network/api_client.dart';
import '../network/session_expired_notifier.dart';
import '../security/secure_token_store.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  sl
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    )
    ..registerLazySingleton<SecureTokenStore>(() => SecureTokenStoreImpl(sl()))
    ..registerLazySingleton<SessionExpiredNotifier>(SessionExpiredNotifier.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(tokenStore: sl(), sessionExpiredNotifier: sl()),
    );

  // Auth
  sl
    ..registerLazySingleton<AuthRemoteService>(() => AuthRemoteService(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteService: sl(), tokenStore: sl()),
    )
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => CheckSession(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => RefreshSession(sl()))
    ..registerFactory(() => LoginCubit(sl()))
    ..registerLazySingleton(
      () => SessionCubit(
        checkSession: sl(),
        getCurrentUser: sl(),
        refreshSession: sl(),
        logout: sl(),
        sessionExpiredNotifier: sl(),
      ),
    );

  // Products
  sl
    ..registerLazySingleton<ProductRemoteService>(
      () => ProductRemoteService(sl()),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => SearchProducts(sl()))
    ..registerLazySingleton(() => GetProductById(sl()))
    ..registerFactory(
      () => ProductListCubit(getProducts: sl(), searchProducts: sl()),
    )
    ..registerFactory(() => ProductDetailCubit(sl()));
}
