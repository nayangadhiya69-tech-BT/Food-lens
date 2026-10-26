import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over [SharedPreferences] for app-level preferences.
///
/// Only non-sensitive state is persisted: locale, onboarding completion,
/// the demo sign-in flag and locally chosen health flags.
/// Passwords and OTP codes are never stored.
///
/// Writes go to an in-memory overlay first and are read back from it
/// before the platform store. If the store is unavailable (a failed init
/// on some devices), the session stays consistent — a flag set to true
/// can never read back as false, which used to bounce users back to the
/// sign-in screen after OTP verification — while a background retry
/// brings the store online and flushes the overlay to disk.
class AppPrefs {
  AppPrefs._();

  static const String keyLocale = 'app_locale';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyDemoAuthenticated = 'demo_authenticated';
  static const String keyHealthFlags = 'health_flags';
  static const String keyTermsAccepted = 'terms_accepted';
  static const String keyUserName = 'user_name';

  static SharedPreferences? _prefs;

  /// Session overlay: written before the store, read before the store.
  /// Single-writer (every entry passes through [_write]), so it is never
  /// stale relative to the store.
  static final Map<String, Object> _memory = <String, Object>{};

  static bool _healing = false;

  /// Restores persisted preferences. Must be awaited before the first
  /// route is chosen (called from `main()`).
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _memory.clear();
    } catch (e) {
      // Keep running on the overlay and retry shortly; main() logs the
      // failure and continues with in-memory defaults.
      unawaited(_retryStoreLater());
      rethrow;
    }
  }

  /// One delayed attempt to bring an unavailable store online, then
  /// flush everything written in the meantime.
  static Future<void> _retryStoreLater() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    await _heal();
  }

  /// Brings the platform store online after a failed init and flushes
  /// the session overlay to it. Single-flight: concurrent writers share
  /// one attempt; a later write retries again if this one fails.
  static Future<void> _heal() async {
    if (_healing || _prefs != null) return;
    _healing = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;
      final pending = Map<String, Object>.of(_memory);
      for (final entry in pending.entries) {
        await _setOn(prefs, entry.key, entry.value);
      }
    } catch (e) {
      debugPrint('AppPrefs store retry failed: $e');
    } finally {
      _healing = false;
    }
  }

  /// Applies one write to the store (typed dispatch).
  static Future<void> _setOn(
    SharedPreferences prefs,
    String key,
    Object value,
  ) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  /// Overlay first, then the store. Never throws: the value is already
  /// visible to every reader in this session, so a broken store must not
  /// fail the flow that logically succeeded (e.g. OTP sign-in). Returns
  /// true once the value is visible.
  static Future<bool> _write(String key, Object value) async {
    _memory[key] = value;
    final prefs = _prefs;
    if (prefs == null) {
      unawaited(_heal());
      return true;
    }
    try {
      await _setOn(prefs, key, value);
    } catch (e) {
      debugPrint('AppPrefs write failed for "$key": $e');
    }
    return true;
  }

  // ---- Locale (null = not explicitly chosen yet) ----

  static String? get localeCode =>
      _memory[keyLocale] as String? ?? _prefs?.getString(keyLocale);

  static Future<bool> setLocaleCode(String code) => _write(keyLocale, code);

  // ---- Onboarding (profile setup) ----

  static bool get onboardingComplete =>
      _memory[keyOnboardingComplete] as bool? ??
      _prefs?.getBool(keyOnboardingComplete) ??
      false;

  static Future<bool> setOnboardingComplete(bool value) =>
      _write(keyOnboardingComplete, value);

  // ---- Terms & Conditions ----

  static bool get termsAccepted =>
      _memory[keyTermsAccepted] as bool? ??
      _prefs?.getBool(keyTermsAccepted) ??
      false;

  static Future<bool> setTermsAccepted(bool value) =>
      _write(keyTermsAccepted, value);

  // ---- User name (chosen once during onboarding) ----

  static String get userName =>
      _memory[keyUserName] as String? ?? _prefs?.getString(keyUserName) ?? '';

  static Future<bool> setUserName(String value) => _write(keyUserName, value);

  // ---- Demo session (local, replaceable by a real auth session later) ----

  static bool get demoAuthenticated =>
      _memory[keyDemoAuthenticated] as bool? ??
      _prefs?.getBool(keyDemoAuthenticated) ??
      false;

  static Future<bool> setDemoAuthenticated(bool value) =>
      _write(keyDemoAuthenticated, value);

  /// Clears only the demo sign-in. Locale and health flags are kept.
  static Future<void> clearDemoSession() async {
    await setDemoAuthenticated(false);
  }

  // ---- Health flags (local-only preference from the design) ----

  static Set<String> get healthFlags =>
      (_memory[keyHealthFlags] as List<String>? ??
              _prefs?.getStringList(keyHealthFlags) ??
              const <String>[])
          .toSet();

  static Future<bool> setHealthFlags(Iterable<String> flags) =>
      _write(keyHealthFlags, List<String>.of(flags));

  // ---- Generic string slot (feature-scoped JSON blobs, e.g. My Day) ----

  /// Reads a raw string value stored under [key], or null when absent.
  static String? getString(String key) =>
      _memory[key] as String? ?? _prefs?.getString(key);

  /// Writes a raw string value under [key].
  static Future<bool> setString(String key, String value) => _write(key, value);
}
