import 'package:bloc/bloc.dart';
import 'package:impacta_project/app/features/register/cubit/register_bloc_state.dart';

import '../../../repositories/register/register_repository.dart';

class RegisterBlocCubit extends Cubit<RegisterBlocState> {
  final RegisterRepository registerRepository;
  RegisterBlocCubit({required this.registerRepository})
    : super(RegisterBlocState.initial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String birthday,
  }) async {
    try {
      emit(state.copyWith(status: RegisterStateStatus.loading));
      final loginValidation = await registerRepository.register(
        name: name,
        email: email,
        password: password,
        birthday: birthday,
      );

      if (loginValidation.name == '') {
        emit(
          state.copyWith(
            status: RegisterStateStatus.error,
            errorMessage: 'Erro ao tentar se logar',
          ),
        );
      }

      emit(
        state.copyWith(
          status: RegisterStateStatus.success,
          userModel: loginValidation,
          successMessage: 'Login realizado com sucesso !',
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: RegisterStateStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }
}
