import 'package:bloc/bloc.dart';

import '../../../repositories/login/login_repository.dart';
import 'login_bloc_state.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final LoginRepository loginRepository;
  LoginBlocCubit({required this.loginRepository})
    : super(LoginBlocState.initial());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(state.copyWith(status: LoginStateStatus.loading));
      final loginValidation = await loginRepository.login(
        email: email,
        password: password,
      );
      if (loginValidation.name.isNotEmpty) {
        emit(
          state.copyWith(
            status: LoginStateStatus.success,
            errorMessage: "Login Realizado com Sucesso!! ",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LoginStateStatus.error,
            errorMessage: "Erro ao efetuar Login",
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }
}
