/// English-only copy for the scan result's status-style decode story.
///
/// The app interface is intentionally always English; the language setting
/// only changes the voice used by the Listen player. Keeping these strings
/// out of the ARB files makes that separation explicit.
class ScanStoryCopy {
  ScanStoryCopy._();

  static const String tag = 'Decode story';
  static const String overviewTitle = 'Your label, decoded';
  static const String shortVersion = 'The short version';
  static const String listenVoiceover = 'Listen AI voiceover';
  static const String listen = 'Listen';
  static const String pause = 'Pause';
  static const String paused = 'Paused';
  static const String tapNext = 'Tap right for next';
  static const String tapBack = 'Tap left to go back';
  static const String endOfStory = "You're at the end";
  static const String reference =
      'Percentages use adult WHO and ICMR-NIN reference values. '
      "Children's reference values are lower.";
  static const String productId = 'Product identification';
  static const String brand = 'Brand';
  static const String product = 'Product';
  static const String netQty = 'Net quantity';
  static const String barcode = 'Barcode';
  static const String scanType = 'Scan type';
  static const String notCaptured = 'Not captured';
  static const String barcodeNote = 'Barcode matched directly on scan.';
  static const String labelOnlyNote =
      'Barcode was not captured; details come from the label images.';
  static const String primaryLens = 'Red-flag sweep';
  static const String whatStandsOut = 'What stands out';
  static const String decodedInDepth = 'Decoded in depth';
  static const String flagsTitle = 'Flags on this label';
  static const String yourFlags = 'Your flags';
  static const String noFlags = 'No personal flags selected for this scan.';
  static const String sources = 'Sources & references';
  static const String sodiumSource = 'Sodium — WHO, 2012';
  static const String sugarSource = 'Free sugars — WHO, 2015';
  static const String sodiumLimit = '2000 mg/day';
  static const String sugarLimit = '50 g/day';
  static const String fssaiNote =
      "FSSAI status: India's front-of-pack rule (Indian Nutrition Rating) "
      "is not finalised, so no official 'high in' threshold exists. Limits "
      'shown are WHO and ICMR-NIN references, not FSSAI limits.';
  static const String replay = 'Replay story';
  static const String voiceUnavailable =
      "Voice playback isn't available on this device.";
  static const String metricSodium = 'SODIUM';
  static const String metricFlags = 'FLAGS';
  static const String metricAdditives = 'ADDITIVES';
  static const String metricAllergens = 'ALLERGENS';
  static const String metricScore = 'SCORE';

  static const String languageEnglish = 'English';
  static const String languageHindi = 'Hindi';
  static const String languageGujarati = 'Gujarati';

  static String languageName(String code) => switch (code) {
    'hi' => languageHindi,
    'gu' => languageGujarati,
    _ => languageEnglish,
  };

  static String listenHint(String language) =>
      'Speaks this story in $language.';

  static String flagsApplied(int count) => count == 1
      ? '1 personal flag is counted in this result.'
      : '$count personal flags are counted in this result.';

  /// Status line for one selected personal flag: is the scanned product
  /// friendly for it (e.g. totally friendly for Jain)?
  static String friendlyStatus(String flagLabel) =>
      'This product is totally friendly for $flagLabel.';

  static String notFriendlyStatus(String flagLabel) =>
      'This product is not friendly for $flagLabel.';
}
