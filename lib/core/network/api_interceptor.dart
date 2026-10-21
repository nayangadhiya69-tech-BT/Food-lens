import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  final String? token;
  final void Function()? onUnauthorized;

  AuthInterceptor({
    this.token,
    this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (token != null && token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('''
      ┌─────────────────────────────────────────────
      │ REQUEST
      ├─────── URI: ${response.requestOptions.uri}
      ├─────── Method: ${response.requestOptions.method}
      ├─────── Status: ${response.statusCode}
      └─────────────────────────────────────────────
      ''');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
      ┌─────────────────────────────────────────────
      │ ERROR
      ├─────── URI: ${err.requestOptions.uri}
      ├─────── Method: ${err.requestOptions.method}
      ├─────── Status: ${err.response?.statusCode}
      ├─────── Message: ${err.message}
      └─────────────────────────────────────────────
      ''');
    }

    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }

    super.onError(err, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (AppConfig.isDebug) {
      debugPrint('''
      ┌─────────────────────────────────────────────
      │ 🚀 REQUEST
      ├─────── URL: ${options.uri}
      ├─────── Method: ${options.method}
      ├─────── Headers: ${_redactedHeaders(options.headers)}
      └─────────────────────────────────────────────
      ''');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (AppConfig.isDebug) {
      debugPrint('''
      ┌─────────────────────────────────────────────
      │ ✅ RESPONSE
      ├─────── URL: ${response.requestOptions.uri}
      ├─────── Status: ${response.statusCode}
      └─────────────────────────────────────────────
      ''');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.isDebug) {
      debugPrint('''
      ┌─────────────────────────────────────────────
      │ ❌ ERROR
      ├─────── URL: ${err.requestOptions.uri}
      ├─────── Status: ${err.response?.statusCode}
      ├─────── Message: ${err.message}
      └─────────────────────────────────────────────
      ''');
    }
    handler.next(err);
  }

  /// Copies [headers] with the Authorization value redacted so tokens are
  /// never written to logs.
  static Map<String, dynamic> _redactedHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    if (copy.containsKey('Authorization')) {
      copy['Authorization'] = '***';
    }
    return copy;
  }
}
