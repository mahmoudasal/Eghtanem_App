import 'package:dio/dio.dart';
import 'package:egtanem_application/core/errors/exceptions.dart';
import 'package:egtanem_application/features/auth/data/services/auth_response.dart';
import 'package:egtanem_application/features/auth/data/services/auth_service.dart';
import 'package:egtanem_application/core/utilities/secure_storage.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _authService.register(name, email, password);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
       final response = await _authService.login(email, password);
       await SecureStorage.storeToken(response.token);
    return response;
     
      
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

 dynamic _handleDioError(DioException e) {
  final statusCode = e.response?.statusCode;
  final errorData = e.response?.data as Map<String, dynamic>?; // تأكد من التحويل الصريح

  if (statusCode == 422) {
    final errors = errorData?['errors'] ?? 'Validation error';
    throw ValidationException(errors);
  }

  final message = errorData?['message'] ?? 'Failed to connect to server';
  throw ServerException(
    message: message,
    statusCode: statusCode,
    dioException: e, // تأكد من تطابق معلمات الباني
  );
}

}
