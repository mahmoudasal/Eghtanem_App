import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await authRepository.login(email: email, password: password);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginError(error.toString()));
    }
  }
  Future<void> autoLogin() async {
    emit(LoginLoading());
    try {
      await authRepository.login(
        email: 'admin@app.com',
        password: '123456',
      );
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginError("تعذر تسجيل الدخول التلقائي"));
    }
  }
}
