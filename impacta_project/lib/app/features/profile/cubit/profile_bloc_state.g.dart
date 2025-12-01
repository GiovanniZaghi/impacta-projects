// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension ProfileStateStatusMatch on ProfileStateStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == ProfileStateStatus.initial) {
      return initial();
    }

    if (v == ProfileStateStatus.loading) {
      return loading();
    }

    if (v == ProfileStateStatus.error) {
      return error();
    }

    if (v == ProfileStateStatus.success) {
      return success();
    }

    throw Exception(
        'ProfileStateStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == ProfileStateStatus.initial && initial != null) {
      return initial();
    }

    if (v == ProfileStateStatus.loading && loading != null) {
      return loading();
    }

    if (v == ProfileStateStatus.error && error != null) {
      return error();
    }

    if (v == ProfileStateStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
