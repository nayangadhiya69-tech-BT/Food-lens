class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User
  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String updateUser = '/user/update';

  // Food
  static const String foods = '/foods';
  static const String foodById = '/foods/{id}';
  static const String searchFood = '/foods/search';
  static const String foodCategories = '/foods/categories';

  // Scan
  static const String scanFood = '/scan';
  static const String scanHistory = '/scan/history';

  // Favorites
  static const String favorites = '/favorites';
  static const String addFavorite = '/favorites/add';
  static const String removeFavorite = '/favorites/remove';
}
