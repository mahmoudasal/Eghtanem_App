import 'package:dio/dio.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:egtanem_application/features/video/data/services/video_service.dart';
import 'package:egtanem_application/features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'package:egtanem_application/core/utilities/secure_storage.dart';
import 'package:egtanem_application/features/video/data/repositories/video_repository.dart';
import 'package:egtanem_application/features/auth/data/repositories/auth_repository.dart';
import 'package:egtanem_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_cuibit.dart';
import 'package:get_it/get_it.dart';


import 'package:egtanem_application/features/auth/data/services/auth_service.dart';
import 'package:egtanem_application/features/video/data/repositories/video_repository_impl.dart';
import 'package:egtanem_application/features/video/presentation/cubit/video_cubit.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final GetIt getIt = GetIt.instance;

// Update injection.dart
 setupDependencies() {
  // Dio with interceptors
  final dio = Dio()
  ..interceptors.add(PrettyDioLogger(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ))
  ..interceptors.add(AuthInterceptor()); // Keep authentication interceptor

  // Services
  getIt.registerSingleton<AuthService>(AuthService(dio));
  getIt.registerSingleton<VideoService>(VideoService(dio));

  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt<AuthService>()));
  getIt.registerSingleton<VideoRepository>(VideoRepositoryImpl(getIt<VideoService>()));

  // Cubits
  getIt.registerFactory(() => LoginCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(() => RegistrationCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(() => VideoCubit(getIt<VideoRepository>()));
  getIt.registerFactory(() => NavigationCubit());
}

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}