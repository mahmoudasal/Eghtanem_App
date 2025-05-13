import 'package:dio/dio.dart';
import 'package:egtanem_application/core/errors/exceptions.dart';
import 'package:egtanem_application/features/auth/data/models/user_model.dart';
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
      // Comment out the actual API call
      // return await _authService.register(name, email, password);

      // Return a mock response instead
      final mockUser = UserModel(
        id: 1,
        name: name,
        email: email,
      );

      final mockAuthResponse = AuthResponse(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        user: mockUser,
      );

      // Store the mock token
      await SecureStorage.storeToken(mockAuthResponse.token);

      return mockAuthResponse;
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
      // Comment out the actual API call
      // final response = await _authService.login(email, password);

      // Return a mock response instead
      final mockUser = UserModel(
        id: 1,
        name: 'مستخدم تجريبي',
        email: email,
      );

      final mockAuthResponse = AuthResponse(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        user: mockUser,
      );

      // Store the mock token
      await SecureStorage.storeToken(mockAuthResponse.token);

      return mockAuthResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data as Map<String, dynamic>?;

    if (statusCode == 422) {
      final errors = errorData?['errors'] ?? 'Validation error';
      throw ValidationException(errors);
    }

    final message = errorData?['message'] ?? 'Failed to connect to server';
    throw ServerException(
      message: message,
      statusCode: statusCode,
      dioException: e,
    );
  }
}
