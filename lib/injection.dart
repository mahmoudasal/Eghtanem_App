import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'core/constants/api_endpoints.dart';
import 'core/network/auth_interceptor.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/presentation/cubit/login_cuibit.dart';
import 'features/auth/presentation/cubit/registration_cubit.dart';
import 'features/home/presentation/navigation_cubit/navigation_cubit.dart';
import 'features/video/data/repositories/video_repository.dart';
import 'features/video/data/repositories/video_repository_impl.dart';
import 'features/video/data/services/video_service.dart';
import 'features/video/presentation/cubit/video_cubit.dart';

final GetIt getIt = GetIt.instance;

// Update injection.dart
setupDependencies() {
  // Dio with interceptors
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(AuthInterceptor());

  // Add PrettyDioLogger only in debug mode
  assert(() {
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
    return true;
  }());

  // Services
  getIt.registerSingleton<AuthService>(AuthService(dio));
  getIt.registerSingleton<VideoService>(VideoService(dio));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthService>()));
  getIt.registerSingleton<VideoRepository>(
      VideoRepositoryImpl(getIt<VideoService>()));

  // Cubits
  getIt.registerFactory(
      () => LoginCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(
      () => RegistrationCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(() => VideoCubit(getIt<VideoRepository>()));
  getIt.registerFactory(() => NavigationCubit());
}
