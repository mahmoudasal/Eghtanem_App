import 'package:egtanem_application/features/auth/data/repositories/auth_repository.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  void loginUser({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await authRepository.login(email: email, password: password);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginError(error.toString()));
    }
  }
}
