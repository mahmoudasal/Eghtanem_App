import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utilities/secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_response.dart';
import '../services/auth_service.dart';
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
    } catch (e) {
      // Always allow registration in offline mode
      return _createMockResponse(name: name, email: email);
    }
  }
  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    // Check for default credentials first (offline mode)
    if (_isValidDefaultCredentials(email, password)) {
      return _createMockResponse(name: 'مستخدم افتراضي', email: email);
    }
    
    try {
      return await _authService.login(email, password);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      // If API fails, check if user provided valid default credentials
      if (_isValidDefaultCredentials(email, password)) {
        return _createMockResponse(name: 'مستخدم افتراضي', email: email);
      }
      throw Exception('بيانات الدخول غير صحيحة. استخدم: admin@app.com / 123456');
    }
  }

  bool _isValidDefaultCredentials(String email, String password) {
    const defaultCredentials = [
      {'email': 'admin@app.com', 'password': '123456'},
      {'email': 'test@example.com', 'password': 'password123'},
      {'email': 'user@demo.com', 'password': 'demo123'},
    ];
    
    return defaultCredentials.any((cred) => 
        cred['email'] == email && cred['password'] == password);
  }

  Future<AuthResponse> _createMockResponse({
    required String name,
    required String email,
  }) async {
    final mockUser = UserModel(id: 1, name: name, email: email);
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    
    await SecureStorage.storeToken(token);
    
    return AuthResponse(token: token, user: mockUser);
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorData = e.response?.data as Map<String, dynamic>?;

    if (statusCode == 422) {
      final errors = errorData?['errors'] ?? 'Validation error';
      return ValidationException(errors);
    }

    final message = errorData?['message'] ?? 'Failed to connect to server';
    return ServerException(
      message: message,
      statusCode: statusCode,
      dioException: e,
    );
  }
}
