import 'package:bloc/bloc.dart';
import 'package:impacta_project/app/features/profile/cubit/profile_bloc_state.dart';

import '../../../repositories/profile/profile_repository.dart';

class ProfileBlocCubit extends Cubit<ProfileBlocState> {
  final ProfileRepository profileRepository;
  ProfileBlocCubit({required this.profileRepository})
    : super(ProfileBlocState.initial());

  Future<void> updateProfile({
    required int id,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: ProfileStateStatus.loading));
      await profileRepository.editProfile(id, name, email, password);
      emit(
        state.copyWith(
          status: ProfileStateStatus.success,
          errorMessage: "Dados alterados com Sucesso!! ",
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ProfileStateStatus.error,
          errorMessage: "Erro ao atualizar",
        ),
      );
    }
  }

  Future<void> delete({required int id}) async {
    try {
      emit(state.copyWith(status: ProfileStateStatus.loading));
      await profileRepository.removeUser(id);
      emit(
        state.copyWith(
          status: ProfileStateStatus.success,
          errorMessage: "Usuario deletado com Sucesso!! ",
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ProfileStateStatus.error,
          errorMessage: "Erro ao atualizar",
        ),
      );
    }
  }
}
