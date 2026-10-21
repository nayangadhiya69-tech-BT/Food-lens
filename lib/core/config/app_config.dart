enum Environment {
  local,
  dev,
  staging,
  prod,
}

class AppConfig {
  AppConfig._();

  /// Change this to switch environments (used for naming/logging only).
  static const Environment environment = Environment.dev;

  /// API base URL is **unset by default** on purpose: no production or
  /// development backend exists yet, so no URL is invented here and no
  /// real request may be made.
  ///
  /// Provide a real value only when a backend exists, at build/run time:
  /// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
  static const String _configuredApiBaseUrl =
      String.fromEnvironment('API_BASE_URL');

  /// The configured API base URL, or `null` when unset/blank.
  static String? get apiBaseUrl {
    final value = _configuredApiBaseUrl.trim();
    return value.isEmpty ? null : value;
  }

  /// Whether a real API base URL has been configured.
  static bool get hasApiBaseUrl => apiBaseUrl != null;

  static String get appName {
    switch (environment) {
      case Environment.local:
        return 'FoodLens (Local)';
      case Environment.dev:
        return 'FoodLens (Dev)';
      case Environment.staging:
        return 'FoodLens (Staging)';
      case Environment.prod:
        return 'FoodLens';
    }
  }

  static const String appVersion = '1.0.0+1';

  static bool get isProduction => environment == Environment.prod;
  static bool get isDebug => environment != Environment.prod;

  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
}
