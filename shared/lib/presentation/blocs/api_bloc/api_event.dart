import 'package:equatable/equatable.dart';

abstract class ApiEvent<T> extends Equatable {
  const ApiEvent();

  @override
  List<Object?> get props => [];
}

/// **Generic GET Request Event**
class FetchDataEvent<T> extends ApiEvent<T> {
  final String endpoint;
  final Map<String, dynamic>? params;

  const FetchDataEvent({required this.endpoint, this.params});

  @override
  List<Object?> get props => [endpoint, params];
}

/// **Generic POST Request Event**
class PostDataEvent<T> extends ApiEvent<T> {
  final String endpoint;
  final Map<String, dynamic> data;

  const PostDataEvent({required this.endpoint, required this.data});

  @override
  List<Object?> get props => [endpoint, data];
}

/// **Generic PUT Request Event**
class PutDataEvent<T> extends ApiEvent<T> {
  final String endpoint;
  final Map<String, dynamic> data;

  const PutDataEvent({required this.endpoint, required this.data});

  @override
  List<Object?> get props => [endpoint, data];
}

/// **Generic DELETE Request Event**
class DeleteDataEvent<T> extends ApiEvent<T> {
  final String endpoint;
  final Map<String, dynamic>? params;

  const DeleteDataEvent({required this.endpoint, this.params});

  @override
  List<Object?> get props => [endpoint, params];
}
