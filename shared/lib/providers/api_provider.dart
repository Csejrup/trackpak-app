import 'package:dio/dio.dart';

import 'providers.dart';

class ApiProvider {
  late Dio _dio;
  final SecureStorageProvider _storageProvider =
      SecureStorageProvider(); // Storage Provider
  final CancelToken _cancelToken =
      CancelToken(); // Request cancellation support

  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        //baseUrl: "https://mongrel-active-completely.ngrok-free.app/api/",
        baseUrl: "http://localhost:5056/api/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Fetch Access Token
          String? accessToken = await _storageProvider.readString(
            'access_token',
          );
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          print("➡️ Sending request to: ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(" Response received: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print("❌ API Error: ${error.message}");

          // Handle Unauthorized (401) - Refresh Token if needed
          if (error.response?.statusCode == 401) {
            bool refreshed = await _refreshToken();
            if (refreshed) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }

          return handler.reject(error);
        },
      ),
    );
  }

  /// **GET Request**
  Future<Response?> getRequest(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  /// **POST Request**
  Future<Response?> postRequest(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  /// **PUT Request**
  Future<Response?> putRequest(
    String endpoint, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      print("❌ PUT Error: $e");
      return null;
    }
  }

  /// **DELETE Request**
  Future<Response?> deleteRequest(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.delete(endpoint, queryParameters: params);
    } catch (e) {
      print("❌ DELETE Error: $e");
      return null;
    }
  }

  /// **Retry Request After Refreshing Token**
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    String? newToken = await _storageProvider.readString('accessToken');
    requestOptions.headers["Authorization"] = "Bearer $newToken";

    return _dio.fetch(requestOptions);
  }

  /// **Refresh Token Logic**
  Future<bool> _refreshToken() async {
    String? refreshToken = await _storageProvider.readString('refreshToken');
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {"refreshToken": refreshToken},
      );
      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        await _storageProvider.writeString(
          'accessToken',
          response.data["accessToken"],
        );
        return true;
      }
    } catch (e) {
      print("❌ Refresh Token Failed: $e");
    }
    return false;
  }

  /// **Error Handling**
  Response? _handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          print("❗ Request was cancelled");
          break;
        case DioExceptionType.connectionTimeout:
          print("❗ Connection timeout");
          break;
        case DioExceptionType.receiveTimeout:
          print("❗ Response timeout");
          break;
        case DioExceptionType.badResponse:
          print("❗ Invalid status code: ${error.response?.statusCode}");
          break;
        case DioExceptionType.unknown:
          print("❗ Unknown error: ${error.message}");
          break;
        default:
          print("❗ Unexpected error");
          break;
      }
    } else {
      print("❗ Unexpected error: $error");
    }
    return null;
  }

  /// **Cancel all ongoing requests**
  void cancelRequests() {
    _cancelToken.cancel("Request cancelled by user.");
  }
}
