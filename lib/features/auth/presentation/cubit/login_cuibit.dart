import 'package:dio/dio.dart';
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
      String errorMessage = "هذه البيانات غير صحيحه";

      if (error is DioException && error.response != null) {
        final responseData = error.response?.data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          final messageData = responseData['message'];

          if (messageData is List) {
            errorMessage = messageData.join("\n"); // Convert list to string
          } else if (messageData is String) {
            errorMessage = messageData;
          }
        }
      }

      emit(LoginError(errorMessage));
    }
  }
}
