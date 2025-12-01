import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'profile_bloc_state.g.dart';

@match
enum ProfileStateStatus { initial, loading, error, success }

class ProfileBlocState extends Equatable {
  final ProfileStateStatus status;
  final String? errorMessage;
  final String? successMessage;

  const ProfileBlocState({
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  ProfileBlocState.initial()
    : status = ProfileStateStatus.initial,
      errorMessage = null,
      successMessage = null;

  @override
  List<Object?> get props => [status, errorMessage, successMessage];

  ProfileBlocState copyWith({
    ProfileStateStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileBlocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
