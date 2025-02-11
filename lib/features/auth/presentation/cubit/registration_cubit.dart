import 'package:egtanem_application/features/auth/data/repositories/auth_repository.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository authRepository;

  RegistrationCubit({required this.authRepository}) : super(RegistrationInitial());

  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegistrationLoading());
    try {
      // ignore: unused_local_variable
      final response = await authRepository.register(name: name, email: email, password: password);
      emit(RegistrationSuccess());
    } catch (error) {
      String errorMessage = "الحساب مسجل بالفعل , يرجى تسجيل الدخول.";

      if (error is DioException && error.response != null) {
        final responseData = error.response?.data;

        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          final messageData = responseData['message'];

          if (messageData is List) {
            errorMessage = messageData.join("\n"); 
          } else if (messageData is String) {
            errorMessage = messageData;
          }
        } else if (error.response?.statusCode == 302) {
          errorMessage = "الحساب مسجل بالفعل. يرجى تسجيل الدخول.";
        } else if (error.response?.statusCode == 400 || error.response?.statusCode == 409) {
          errorMessage = "هذا البريد الإلكتروني مستخدم بالفعل!";
        }
      }

      emit(RegistrationError(errorMessage));
    }
  }
}
