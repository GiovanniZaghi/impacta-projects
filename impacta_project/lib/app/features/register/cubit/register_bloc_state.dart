import 'package:equatable/equatable.dart';
import 'package:impacta_project/app/model/user_model.dart';
import 'package:match/match.dart';

part 'register_bloc_state.g.dart';

@match
enum RegisterStateStatus { initial, loading, error, success }

class RegisterBlocState extends Equatable {
  final UserModel userModel;
  final RegisterStateStatus status;
  final String? errorMessage;
  final String? successMessage;

  const RegisterBlocState({
    required this.userModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  RegisterBlocState.initial()
    : userModel = UserModel(name: '', email: ''),
      status = RegisterStateStatus.initial,
      errorMessage = null,
      successMessage = null;

  @override
  List<Object?> get props => [status, errorMessage, successMessage];

  RegisterBlocState copyWith({
    UserModel? userModel,
    RegisterStateStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return RegisterBlocState(
      userModel: userModel ?? this.userModel,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
