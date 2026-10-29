import '../../../core/models/health_flag.dart';
import '../model/scan_result.dart';

/// Spoken scripts for the decode story.
///
/// The screen text is always English; these scripts provide the same story
/// in the language selected for the Listen voiceover. They are never shown
/// in the interface.
class ScanStoryVoice {
  ScanStoryVoice._();

  static String scriptFor({
    required int card,
    required String languageCode,
    required ScanResult result,
    required Set<HealthFlag> flags,
    String? barcode,
  }) {
    final barcodeText = (barcode?.trim().isNotEmpty ?? false)
        ? barcode!.trim()
        : null;
    return switch (languageCode) {
      'hi' => _hindi(card, result, flags, barcodeText),
      'gu' => _gujarati(card, result, flags, barcodeText),
      _ => _english(card, result, flags, barcodeText),
    };
  }

  static String _english(
    int card,
    ScanResult result,
    Set<HealthFlag> flags,
    String? barcode,
  ) {
    switch (card) {
      case 0:
        final names = _flagNames(flags, 'en');
        return 'This is the decode story for ${result.name}. '
            '${result.subtitle}. '
            '${names.isEmpty ? 'No personal flags are selected.' : 'Your flags: $names.'} '
            '${result.flaggedCount} things are flagged on this label. '
            'Every figure is read from the printed label. Rest is your choice.';
      case 1:
        return 'Product identification. ${result.name}. ${result.subtitle}. '
            'Barcode: ${barcode ?? 'not captured'}.';
      case 2:
        return 'Primary lens and red-flag sweep. '
            'Sodium: ${_stat(result, ScanStatKey.sodium)}. '
            'Personal flags: ${_stat(result, ScanStatKey.condition)}. '
            'Additives: ${_stat(result, ScanStatKey.additives)}. '
            'Allergens: ${_stat(result, ScanStatKey.allergens)}. '
            'Label read score: ${_stat(result, ScanStatKey.score)}. '
            '${result.bannerBody}';
      case 3:
        return '${result.depth.title}. ${result.depth.amount} '
            '${result.depth.detail}, ${result.depth.percent}. '
            'Ingredient: ${result.depth.ingredient}. ${result.depth.note}';
      case 4:
        final rows = result.labelFlags
            .map((flag) => '${flag.title}: ${flag.value}')
            .join('. ');
        return 'Flags on this label. $rows.';
      default:
        return 'Sources and references. Sodium: WHO 2012, 2000 milligrams '
            'per day. Free sugars: WHO 2015, 50 grams per day. FSSAI status: '
            "India's front-of-pack rule is not finalised, so the limits "
            'shown are WHO and ICMR-NIN references, not FSSAI limits. '
            'Every figure is read from the printed label. FoodLens does not '
            'give medical advice.';
    }
  }

  static String _flagName(HealthFlag flag, String language) {
    switch (language) {
      case 'hi':
        return switch (flag) {
          HealthFlag.diabetes => 'मधुमेह',
          HealthFlag.bloodPressure => 'उच्च रक्तचाप',
          HealthFlag.cholesterol => 'कोलेस्ट्रॉल',
          HealthFlag.pregnancy => 'गर्भावस्था',
          HealthFlag.jain => 'जैन',
          HealthFlag.swaminarayan => 'स्वामिनारायण',
          HealthFlag.none => 'कोई नहीं',
        };
      case 'gu':
        return switch (flag) {
          HealthFlag.diabetes => 'ડાયાબિટીસ',
          HealthFlag.bloodPressure => 'હાઈ બ્લડ પ્રેશર',
          HealthFlag.cholesterol => 'કોલેસ્ટ્રોલ',
          HealthFlag.pregnancy => 'ગર્ભાવસ્થા',
          HealthFlag.jain => 'જૈન',
          HealthFlag.swaminarayan => 'સ્વામિનારાયણ',
          HealthFlag.none => 'કંઈ નહીં',
        };
      default:
        return switch (flag) {
          HealthFlag.diabetes => 'diabetes',
          HealthFlag.bloodPressure => 'blood pressure',
          HealthFlag.cholesterol => 'cholesterol',
          HealthFlag.pregnancy => 'pregnancy',
          HealthFlag.jain => 'Jain',
          HealthFlag.swaminarayan => 'Swaminarayan',
          HealthFlag.none => 'none',
        };
    }
  }

  static String _flagNames(Set<HealthFlag> flags, String language) {
    final names = <String>[];
    for (final flag in flags) {
      if (flag.isNone) continue;
      names.add(_flagName(flag, language));
    }
    return names.join(', ');
  }

  static String _gujarati(
    int card,
    ScanResult result,
    Set<HealthFlag> flags,
    String? barcode,
  ) {
    switch (card) {
      case 0:
        final names = _flagNames(flags, 'gu');
        return 'આ ${result.name} ની ડિકોડ સ્ટોરી છે. 800 ગ્રામ બોક્સ, અંદર '
            '10 મિની પેક. '
            '${names.isEmpty ? 'કોઈ વ્યક્તિગત ફ્લેગ પસંદ કરવામાં આવ્યો નથી.' : 'તમારા ફ્લેગ: $names.'} '
            'આ લેબલ પર ${result.flaggedCount} વસ્તુઓ ફ્લેગ થઈ છે. દરેક '
            'આંકડો છપાયેલા લેબલ પરથી વાંચેલો છે. બાકી તમારી મરજી.';
      case 1:
        return 'પ્રોડક્ટ ઓળખ. ${result.name}. 800 ગ્રામ બોક્સ, અંદર 10 મિની '
            'પેક. બારકોડ: ${barcode ?? 'કૅપ્ચર થયો નથી'}.';
      case 2:
        return 'પ્રાઇમરી લેન્સ અને રેડ-ફ્લેગ સ્વીપ. સોડિયમ: '
            '${_stat(result, ScanStatKey.sodium)}. તમારા ફ્લેગ: '
            '${_stat(result, ScanStatKey.condition)}. એડિટિવ્સ: '
            '${_stat(result, ScanStatKey.additives)}. એલર્જન: '
            '${_stat(result, ScanStatKey.allergens)}. લેબલ રીડ સ્કોર: '
            '${_stat(result, ScanStatKey.score)}. એડેડ સુગર, સેચ્યુરેટેડ '
            'ફેટ અને છુપો સોડિયમ 80 ગ્રામ પેકના હિસાબે WHO અને ICMR-NINની '
            'પુખ્ત દૈનિક મર્યાદા કરતાં વધે છે.';
      case 3:
        return 'સેચ્યુરેટેડ અને ટ્રાન્સ ફેટ. 13.7 ગ્રામ કુલ ફેટ, જેમાં 6.5 '
            'ગ્રામ સેચ્યુરેટેડ, પ્રતિ 80 ગ્રામ. આ પુખ્ત દૈનિક મર્યાદાના 30 '
            'ટકા છે. સ્રોત: એડિબલ વેજિટેબલ ઓઇલ, પામ ઓઇલ. પામ ઓઇલમાં '
            'સેચ્યુરેટેડ ફેટ વધુ હોય છે.';
      case 4:
        return 'આ લેબલ પર ફ્લેગ. એડેડ સુગર: 17.8 ગ્રામ, 36 ટકા. છુપો '
            'સોડિયમ 4 સ્રોતોથી: 14 ટકા.';
      default:
        return 'સ્રોત અને સંદર્ભ. સોડિયમ: WHO 2012, 2000 મિલિગ્રામ પ્રતિદિન. '
            'ફ્રી સુગર: WHO 2015, 50 ગ્રામ પ્રતિદિન. FSSAI સ્થિતિ: ભારતનો '
            'ફ્રન્ટ-ઓફ-પેક નિયમ હજુ નક્કી થયો નથી, તેથી બતાવેલી મર્યાદાઓ '
            'WHO અને ICMR-NIN સંદર્ભ છે, FSSAI મર્યાદાઓ નથી. દરેક આંકડો '
            'છપાયેલા લેબલ પરથી વાંચેલો છે. FoodLens તબીબી સલાહ આપતું નથી.';
    }
  }

  static String _hindi(
    int card,
    ScanResult result,
    Set<HealthFlag> flags,
    String? barcode,
  ) {
    switch (card) {
      case 0:
        final names = _flagNames(flags, 'hi');
        return 'यह ${result.name} की डिकोड स्टोरी है। 800 ग्राम का डिब्बा, '
            'अंदर 10 मिनी पैक। '
            '${names.isEmpty ? 'कोई व्यक्तिगत फ़्लैग नहीं चुना गया।' : 'आपके फ़्लैग: $names.'} '
            'इस लेबल पर ${result.flaggedCount} चीज़ें फ़्लैग की गई हैं। '
            'हर आंकड़ा छपे हुए लेबल से पढ़ा गया है। बाकी आपकी मर्ज़ी।';
      case 1:
        return 'प्रोडक्ट पहचान। ${result.name}. 800 ग्राम का डिब्बा, अंदर '
            '10 मिनी पैक। बारकोड: ${barcode ?? 'कैप्चर नहीं हुआ'}।';
      case 2:
        return 'प्राइमरी लेंस और रेड-फ्लैग स्वीप। सोडियम: '
            '${_stat(result, ScanStatKey.sodium)}. आपके फ़्लैग: '
            '${_stat(result, ScanStatKey.condition)}. एडिटिव्स: '
            '${_stat(result, ScanStatKey.additives)}. एलर्जन: '
            '${_stat(result, ScanStatKey.allergens)}. लेबल रीड स्कोर: '
            '${_stat(result, ScanStatKey.score)}. एडेड शुगर, सैचुरेटेड फैट '
            'और छिपा सोडियम 80 ग्राम पैक के हिसाब से WHO और ICMR-NIN की '
            'वयस्क दैनिक सीमा से ऊपर जाते हैं।';
      case 3:
        return 'सैचुरेटेड और ट्रांस फैट। 13.7 ग्राम कुल फैट, जिसमें 6.5 ग्राम '
            'सैचुरेटेड, प्रति 80 ग्राम। यह वयस्क दैनिक सीमा का 30 प्रतिशत '
            'है। स्रोत: एडिबल वेजिटेबल ऑयल, पाम ऑयल। पाम ऑयल में '
            'सैचुरेटेड फैट ज़्यादा होता है।';
      case 4:
        return 'इस लेबल पर फ़्लैग। एडेड शुगर: 17.8 ग्राम, 36 प्रतिशत। छिपा '
            'सोडियम 4 स्रोतों से: 14 प्रतिशत।';
      default:
        return 'स्रोत और संदर्भ। सोडियम: WHO 2012, 2000 मिलीग्राम प्रतिदिन। '
            'फ्री शुगर: WHO 2015, 50 ग्राम प्रतिदिन। FSSAI स्थिति: भारत का '
            'फ्रंट-ऑफ-पैक नियम अभी तय नहीं हुआ है, इसलिए दिखाई गई सीमाएं '
            'WHO और ICMR-NIN संदर्भ हैं, FSSAI सीमाएं नहीं। हर आंकड़ा छपे '
            'हुए लेबल से पढ़ा गया है। FoodLens चिकित्सीय सलाह नहीं देता।';
    }
  }

  static String _stat(ScanResult result, ScanStatKey key) {
    for (final stat in result.stats) {
      if (stat.key == key) return stat.value;
    }
    return '0';
  }
}
