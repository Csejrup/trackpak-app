import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/providers.dart';
import 'api_event.dart';
import 'api_state.dart';

class ApiBloc<T> extends Bloc<ApiEvent<T>, ApiState<T>> {
  final ApiProvider apiProvider;

  ApiBloc({required this.apiProvider}) : super(ApiInitial<T>()) {
    on<FetchDataEvent<T>>(_onFetchData);
    on<PostDataEvent<T>>(_onPostData);
    on<PutDataEvent<T>>(_onPutData);
    on<DeleteDataEvent<T>>(_onDeleteData);
  }

  /// **Handle GET Requests**
  Future<void> _onFetchData(
    FetchDataEvent<T> event,
    Emitter<ApiState<T>> emit,
  ) async {
    emit(ApiLoading<T>());
    try {
      final response = await apiProvider.getRequest(
        event.endpoint,
        params: event.params,
      );
      if (response?.statusCode == 200) {
        emit(ApiSuccess<T>(response!.data as T)); // Cast to the generic type
      } else {
        emit(ApiFailure<T>('Failed to fetch data.'));
      }
    } catch (e) {
      emit(ApiFailure<T>('Error: $e'));
    }
  }

  /// **Handle POST Requests**
  Future<void> _onPostData(
    PostDataEvent<T> event,
    Emitter<ApiState<T>> emit,
  ) async {
    emit(ApiLoading<T>());
    try {
      final response = await apiProvider.postRequest(
        event.endpoint,
        data: event.data,
      );
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        emit(ApiSuccess<T>(response!.data as T));
      } else {
        emit(ApiFailure<T>('Failed to post data.'));
      }
    } catch (e) {
      emit(ApiFailure<T>('Error: $e'));
    }
  }

  /// **Handle PUT Requests**
  Future<void> _onPutData(
    PutDataEvent<T> event,
    Emitter<ApiState<T>> emit,
  ) async {
    emit(ApiLoading<T>());
    try {
      final response = await apiProvider.putRequest(
        event.endpoint,
        data: event.data,
      );
      if (response?.statusCode == 200 || response?.statusCode == 204) {
        emit(ApiSuccess<T>(response!.data as T));
      } else {
        emit(ApiFailure<T>('Failed to update data.'));
      }
    } catch (e) {
      emit(ApiFailure<T>('Error: $e'));
    }
  }

  /// **Handle DELETE Requests**
  Future<void> _onDeleteData(
    DeleteDataEvent<T> event,
    Emitter<ApiState<T>> emit,
  ) async {
    emit(ApiLoading<T>());
    try {
      final response = await apiProvider.deleteRequest(
        event.endpoint,
        params: event.params,
      );
      if (response?.statusCode == 200 || response?.statusCode == 204) {
        emit(ApiSuccess<T>(response!.data as T));
      } else {
        emit(ApiFailure<T>('Failed to delete data.'));
      }
    } catch (e) {
      emit(ApiFailure<T>('Error: $e'));
    }
  }
}
