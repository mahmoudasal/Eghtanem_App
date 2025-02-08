import 'package:egtanem_application/features/auth/data/repositories/auth_repository.dart';
import 'package:egtanem_application/features/auth/presentation/cubit/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




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
      await authRepository.register(name: name, email: email, password: password);
      emit(RegistrationSuccess());
    } catch (error) {
      emit(RegistrationError(error.toString()));
    }
  }
}
