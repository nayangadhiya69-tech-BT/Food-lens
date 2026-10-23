import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  AppUtils._();

  // Misc
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  // Date Formatting
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(
    DateTime date, {
    String format = 'dd MMM yyyy, hh:mm a',
  }) {
    return DateFormat(format).format(date);
  }

  /// Formats a 10-digit number as "98765 43210" (as shown in the HTML design).
  static String formatMobile(String phone) {
    final digits = phone.replaceAll(RegExp(r'[\s-]'), '');
    if (digits.length != 10) return phone;
    return '${digits.substring(0, 5)} ${digits.substring(5)}';
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Indian mobile number: exactly 10 digits starting with 6-9.
  static bool isValidIndianMobile(String phone) {
    final digits = phone.replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
  }

  /// Demo OTP format: exactly 6 digits.
  static bool isValidOtp(String code) {
    return RegExp(r'^\d{6}$').hasMatch(code);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // UI Helpers
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  static String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
