import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          responseType: ResponseType.json,
        )) {
    _dio.interceptors.add(SentryDioInterceptor());
  }

  Dio get dio => _dio;
}

class SentryDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Sentry.captureException(
      err,
      stackTrace: err.stackTrace,
    );

    super.onError(err, handler);
  }
}
