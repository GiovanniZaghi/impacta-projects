// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension TaskStateStatusMatch on TaskStateStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == TaskStateStatus.initial) {
      return initial();
    }

    if (v == TaskStateStatus.loading) {
      return loading();
    }

    if (v == TaskStateStatus.error) {
      return error();
    }

    if (v == TaskStateStatus.success) {
      return success();
    }

    throw Exception('TaskStateStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == TaskStateStatus.initial && initial != null) {
      return initial();
    }

    if (v == TaskStateStatus.loading && loading != null) {
      return loading();
    }

    if (v == TaskStateStatus.error && error != null) {
      return error();
    }

    if (v == TaskStateStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
