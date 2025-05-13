import 'package:egtanem_application/features/auth/data/repositories/auth_repository.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  // Auto login function that doesn't require credentials
  void autoLogin() async {
    emit(LoginLoading());
    try {
      // Define a default test account or use hardcoded values
      const defaultEmail = 'test@example.com';
      const defaultPassword = 'password123';

      // Use the existing login method with default credentials
      await authRepository.login(
          email: defaultEmail, password: defaultPassword);

      // Alternatively, you could bypass the repository call entirely
      // and directly store a fake token
      // await SecureStorage.storeToken('fake_auto_login_token');

      emit(LoginSuccess());
    } catch (error) {
      // In case of error, show a generic message
      emit(LoginError("تعذر تسجيل الدخول التلقائي"));
    }
  }

  // Modified login method still available if needed
  void loginUser({required String email, required String password}) async {
    // Skip actual credentials and use auto login instead
    autoLogin();
  }
}
