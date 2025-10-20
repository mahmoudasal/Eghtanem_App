import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository authRepository;

  RegistrationCubit({required this.authRepository}) : super(RegistrationInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegistrationLoading());
    try {
      await authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      emit(RegistrationSuccess());
    } catch (error) {
      emit(RegistrationError(_getErrorMessage(error)));
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    if (errorString.contains('409') || errorString.contains('already exists')) {
      return "هذا البريد الإلكتروني مستخدم بالفعل!";
    }
    if (errorString.contains('400') || errorString.contains('validation')) {
      return "يرجى التحقق من صحة البيانات المدخلة.";
    }
    return "حدث خطأ أثناء إنشاء الحساب. يرجى المحاولة مرة أخرى.";
  }
}
