import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'api_interceptor.dart';
import 'api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  String? _authToken;
  void Function()? _onUnauthorized;
  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        // Unset API base URL resolves to '' which is a valid (relative-only)
        // configuration; every request is additionally guarded below so no
        // call can leave the device while no backend is configured.
        baseUrl: AppConfig.apiBaseUrl ?? '',
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(token: _authToken, onUnauthorized: _onUnauthorized),
      if (AppConfig.isDebug) LoggingInterceptor(),
    ]);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJson,
  }) async {
    if (!AppConfig.hasApiBaseUrl) return _unconfigured<T>();
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleSuccess<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJson,
  }) async {
    if (!AppConfig.hasApiBaseUrl) return _unconfigured<T>();
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleSuccess<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJson,
  }) async {
    if (!AppConfig.hasApiBaseUrl) return _unconfigured<T>();
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleSuccess<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJson,
  }) async {
    if (!AppConfig.hasApiBaseUrl) return _unconfigured<T>();
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleSuccess<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  void setAuthToken(String? token) {
    _authToken = token;
    _updateAuthInterceptor();
  }

  void setUnauthorizedCallback(void Function() callback) {
    _onUnauthorized = callback;
    _updateAuthInterceptor();
  }

  String _extractErrorMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map;
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Server error';
    }
    return 'Server error';
  }

  ApiResponse<T> _handleError<T>(DioException e) {
    String message;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message = _extractErrorMessage(e.response);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }

    if (kDebugMode) {
      debugPrint('API Error: $message | Status: ${e.response?.statusCode}');
    }

    return ApiResponse.error(
      message: message,
      statusCode: e.response?.statusCode ?? 500,
    );
  }

  ApiResponse<T> _handleSuccess<T>(
    Response response,
    T Function(dynamic data)? fromJson,
  ) {
    final data = response.data;
    return ApiResponse.success(
      data: fromJson != null ? fromJson(data) : data as T?,
      message: data is Map ? data['message'] as String? : null,
    );
  }

  ApiResponse<T> _unconfigured<T>() {
    if (kDebugMode) {
      debugPrint('API call blocked: API_BASE_URL is not configured.');
    }
    return ApiResponse<T>.error(
      message: 'API base URL is not configured.',
      statusCode: 0,
    );
  }

  void _updateAuthInterceptor() {
    dio.interceptors.removeWhere((i) => i is AuthInterceptor);
    dio.interceptors.insert(
      0,
      AuthInterceptor(token: _authToken, onUnauthorized: _onUnauthorized),
    );
  }
}
