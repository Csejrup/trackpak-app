import 'package:equatable/equatable.dart';

abstract class ApiState<T> extends Equatable {
  const ApiState();

  @override
  List<Object?> get props => [];
}

/// **Initial State**
class ApiInitial<T> extends ApiState<T> {}

/// **Loading State**
class ApiLoading<T> extends ApiState<T> {}

/// **Success State**
class ApiSuccess<T> extends ApiState<T> {
  final T data;

  const ApiSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// **Failure State**
class ApiFailure<T> extends ApiState<T> {
  final String message;

  const ApiFailure(this.message);

  @override
  List<Object?> get props => [message];
}
