import 'package:egtanem_application/features/auth/data/services/auth_response.dart';



abstract class AuthRepository {
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
  });
}
