import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/core/config/app_config.dart';
import 'package:foodlens/core/network/api_client.dart';

void main() {
  // API_BASE_URL is intentionally unset in tests (and in the shipped app):
  // no backend exists yet, so no request may leave the device.
  test('apiBaseUrl is unset by default', () {
    expect(AppConfig.apiBaseUrl, isNull);
    expect(AppConfig.hasApiBaseUrl, isFalse);
  });

  group('ApiClient with unset base URL', () {
    late ApiClient client;

    setUp(() {
      client = ApiClient();
    });

    test('get is blocked without throwing', () async {
      final response = await client.get<Map<String, dynamic>>('/anything');
      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 0);
      expect(response.message, 'API base URL is not configured.');
    });

    test('post is blocked without throwing', () async {
      final response = await client.post<Map<String, dynamic>>(
        '/anything',
        data: const {'a': 1},
      );
      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 0);
    });

    test('put is blocked without throwing', () async {
      final response = await client.put<Map<String, dynamic>>('/anything');
      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 0);
    });

    test('delete is blocked without throwing', () async {
      final response = await client.delete<Map<String, dynamic>>('/anything');
      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 0);
    });
  });
}
