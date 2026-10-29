import 'package:flutter_tts/flutter_tts.dart';

/// Thin wrapper around the platform text-to-speech engine.
///
/// The engine is created lazily so widget tests and camera-only screens
/// never touch the platform channel. Every call is best-effort: an
/// unavailable engine simply makes [speak] return false.
class VoiceService {
  FlutterTts? _tts;
  bool _configured = false;

  /// Speaks [text] with the voice for [languageCode] (`en`, `hi`, `gu`).
  ///
  /// Completes when the utterance finishes (or is stopped). Returns false
  /// when the engine is unavailable or rejected the request.
  Future<bool> speak({
    required String text,
    required String languageCode,
  }) async {
    if (text.trim().isEmpty) return false;
    try {
      final tts = _tts ??= FlutterTts();
      if (!_configured) {
        await tts.awaitSpeakCompletion(true);
        await tts.setSpeechRate(0.48);
        await tts.setPitch(1.0);
        await tts.setVolume(1.0);
        _configured = true;
      }
      await tts.stop();

      var language = _bcp47(languageCode);
      try {
        final available = await tts.isLanguageAvailable(language);
        if (!(available == true || available == 1)) {
          language = 'en-IN';
        }
      } catch (_) {
        // Some engines do not implement the check; try the voice anyway.
      }

      await tts.setLanguage(language);
      final result = await tts.speak(text);
      return result != null;
    } catch (_) {
      return false;
    }
  }

  /// Stops any current utterance. Safe to call before the engine exists.
  Future<void> stop() async {
    final tts = _tts;
    if (tts == null) return;
    try {
      await tts.stop();
    } catch (_) {
      // Best effort — the platform engine may already be gone.
    }
  }

  Future<void> dispose() async {
    await stop();
    _tts = null;
    _configured = false;
  }

  static String _bcp47(String code) => switch (code) {
    'hi' => 'hi-IN',
    'gu' => 'gu-IN',
    _ => 'en-IN',
  };
}
