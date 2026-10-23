// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'FoodLens';

  @override
  String get appTagline =>
      'कोई भी पैकेज्ड फ़ूड लेबल स्कैन करें और उस पर क्या छपा है — अपनी भाषा में देखें।';

  @override
  String get actionRetry => 'फिर से कोशिश करें';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionContinue => 'जारी रखें';

  @override
  String get actionSkipForNow => 'अभी छोड़ें';

  @override
  String get actionBack => 'वापस';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get actionSignOut => 'साइन आउट';

  @override
  String get phonePrefix => '+91';

  @override
  String get loginTitle => 'अपना मोबाइल नंबर दर्ज करें';

  @override
  String get loginSubtitle => 'हम आपकी पुष्टि के लिए एक बार का कोड भेजेंगे।';

  @override
  String get mobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get phoneHint => 'कृपया अपना नंबर दर्ज करें';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get termsCaption =>
      'जारी रखने पर आप FoodLens की शर्तों और गोपनीयता नीति से सहमत होते हैं।';

  @override
  String get demoSignInNotice =>
      'डेमो साइन-इन — कोई SMS नहीं भेजा जाता। कोड अगली स्क्रीन पर मिलेगा।';

  @override
  String get phoneRequiredError => 'मोबाइल नंबर ज़रूरी है';

  @override
  String get phoneInvalidError => 'मान्य 10-अंकीय नंबर दर्ज करें';

  @override
  String get otpTitle => 'अपने नंबर की पुष्टि करें';

  @override
  String otpSubtitle(String phone) {
    return '$phone के लिए 6-अंकीय कोड दर्ज करें';
  }

  @override
  String otpDemoNotice(String code) {
    return 'डेमो मोड — कोई SMS नहीं भेजा गया। कोड $code उपयोग करें।';
  }

  @override
  String get otpVerify => 'सत्यापित करें और जारी रखें';

  @override
  String get otpVerifying => 'सत्यापित हो रहा है…';

  @override
  String otpResendIn(String time) {
    return '$time में कोड दोबारा भेजें';
  }

  @override
  String get otpResendReady => 'कोड दोबारा भेजें';

  @override
  String get otpResendLimitReached =>
      'इस डेमो सत्र के लिए दोबारा भेजने की सीमा पूरी हो गई है।';

  @override
  String otpResent(String code) {
    return 'नया डेमो कोड तैयार है — $code उपयोग करें।';
  }

  @override
  String get otpIncompleteError => 'सभी 6 अंक दर्ज करें';

  @override
  String get otpMismatchError => 'कोड मेल नहीं खाया। फिर से कोशिश करें।';

  @override
  String get otpTooManyAttemptsError =>
      'बहुत अधिक प्रयास हो गए। डेमो साइन-इन फिर से शुरू करें।';

  @override
  String get setupTitle => 'कुछ छोटी बातें';

  @override
  String get preferredLanguageLabel => 'पसंदीदा भाषा';

  @override
  String get flagQuestionLabel =>
      'मौजूद होने पर, किन चीज़ों के लिए ध्यान रखें?';

  @override
  String get flagNote =>
      'यह केवल तय करता है कि कौन-से फ़्लैग पहले दिखेंगे — लेबल पर क्या छपा है, इसमें कोई बदलाव नहीं।';

  @override
  String get flagDiabetes => 'मधुमेह';

  @override
  String get flagBloodPressure => 'रक्तचाप';

  @override
  String get flagCholesterol => 'कोलेस्ट्रॉल';

  @override
  String get flagPregnancy => 'गर्भावस्था';

  @override
  String get flagNoneOfThese => 'इनमें से कोई नहीं';

  @override
  String get termsTitle => 'नियम और शर्तें';

  @override
  String get termsIntro =>
      'आगे बढ़ने से पहले कृपया FoodLens की इन शर्तों को पढ़ें।';

  @override
  String get termsAiHeading => 'AI-जनित परिणाम';

  @override
  String get termsAiBody =>
      'FoodLens में सभी डेटा और प्रोडक्ट स्कैन परिणाम AI-जनित हैं।';

  @override
  String get termsVerifyHeading => 'महत्वपूर्ण डेटा सत्यापित करें';

  @override
  String get termsVerifyBody =>
      'भरोसा करने से पहले किसी भी महत्वपूर्ण जानकारी — जैसे एलर्जेन, पोषण मूल्य या स्वास्थ्य संबंधी विवरण — की जाँच प्रोडक्ट के प्रिंटेड लेबल या किसी योग्य पेशेवर से करें।';

  @override
  String get termsHealthHeading => 'केवल स्वास्थ्य रीडिंग';

  @override
  String get termsHealthBody =>
      'हमारा उद्देश्य केवल जानकारी के लिए AI-जनित स्वास्थ्य रीडिंग देना है। FoodLens किसी ब्रांड को स्वास्थ्य के लिए अच्छा या बुरा करार देने का इरादा नहीं रखता, और यहाँ कुछ भी चिकित्सकीय सलाह नहीं है।';

  @override
  String get termsAgreeLabel =>
      'मैंने उपरोक्त पढ़ लिया है, समझ लिया है, और मैं सहमत हूँ।';

  @override
  String get termsNext => 'आगे बढ़ें';

  @override
  String get nameTitle => 'आपका नाम क्या है?';

  @override
  String get nameSubtitle =>
      'हम इसका उपयोग ऐप में आपका अभिवादन करने के लिए करेंगे।';

  @override
  String get nameLabel => 'आपका नाम';

  @override
  String get nameHint => 'अपना नाम दर्ज करें';

  @override
  String get nameRequiredError => 'कृपया अपना नाम दर्ज करें';

  @override
  String get languageScreenTitle => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get languageSwitcherLabel => 'भाषा चुनें';

  @override
  String get navHome => 'होम';

  @override
  String get navMyDay => 'मेरा दिन';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get myDayTitle => 'मेरा दिन';

  @override
  String get myDayEmptyTitle => 'अभी कुछ नहीं है';

  @override
  String get myDayEmptySubtitle => 'आपकी दैनिक हाइलाइट्स यहाँ दिखेंगी।';

  @override
  String get myDayError => 'मेरा दिन लोड नहीं हो सका। कृपया पुनः प्रयास करें।';

  @override
  String get myDayPickTitle => 'आज क्या खाया';

  @override
  String get myDayPickSubtitle => 'आज जो कुछ भी खाया उसे चुनें';

  @override
  String get myDayRecentScansLabel => 'आपके हाल के स्कैन';

  @override
  String get myDayPickNote =>
      'यहाँ केवल वही चीज़ें दिखती हैं जो आपने स्कैन की हैं। इस सूची में जोड़ने के लिए नया पैक स्कैन करें।';

  @override
  String get myDayParseAdd => 'पार्स करें और सूची में जोड़ें';

  @override
  String get myDayNothingSelected => 'आगे बढ़ने के लिए कम से कम एक आइटम चुनें।';

  @override
  String get myDayAmountTitle => 'कितना लिया?';

  @override
  String get myDayAmountSubtitle =>
      'जैसा आप बोलते हैं वैसे बताएं — चम्मच, गिलास, कटोरी';

  @override
  String get myDayAmountNote =>
      'कोई स्नैक तोलता नहीं। वह नाप चुनें जो आपने सच में इस्तेमाल किया। फ़ूडलेंस हर प्रोडक्ट की अपनी घनत्व से उसे ग्राम में बदल देता है।';

  @override
  String get myDayEditQuantity => 'मात्रा संपादित करें';

  @override
  String myDayGramsCounted(String grams) {
    return '$grams ग्राम';
  }

  @override
  String get myDayQuantityInvalid => 'शून्य से अधिक मान्य मात्रा दर्ज करें।';

  @override
  String get myDayQuantityTooHigh => 'मात्रा पूरे पैक से अधिक नहीं हो सकती।';

  @override
  String get myDayCalculate => 'मेरा दिन गणना करें';

  @override
  String get myDayCalculating => 'गणना हो रही है…';

  @override
  String myDaySummarySubtitle(int count) {
    return '$count आइटम · आज बनाम आपकी दैनिक सीमाएं';
  }

  @override
  String get myDayAgainstLimitLabel => 'आज दैनिक सीमा के विरुद्ध';

  @override
  String get myDayDailyLimit => 'दैनिक सीमा';

  @override
  String myDayRemaining(String amount) {
    return '$amount शेष';
  }

  @override
  String myDayOverBy(String amount) {
    return '$amount अधिक';
  }

  @override
  String get myDayWhatMadeItUp => 'इसमें क्या शामिल है';

  @override
  String get myDayHoneyNote =>
      'शहद सुधारा गया। आपके आंकड़ों में शहद 0g चीनी था। WHO शहद को फ्री शुगर (~82g प्रति 100g) मानता है, इसलिए यहाँ शामिल है — इसी से चीनी सीमा पार होती है।';

  @override
  String get myDaySourceNote =>
      'हर आंकड़ा प्रति-100g × खाए गए ग्राम ÷ 100 है। सीमाएं WHO वयस्क संदर्भ हैं, FSSAI सीमाएं नहीं।';

  @override
  String get myDayAddAnother => 'एक और आइटम जोड़ें';

  @override
  String get myDayGoHome => 'होम पर जाएं';

  @override
  String myDayRemoveItem(String name) {
    return '$name हटाएं';
  }

  @override
  String get myDaySaveError =>
      'आज की प्रविष्टियां सहेजी नहीं जा सकीं। कृपया पुनः प्रयास करें।';

  @override
  String myDayChipSugar(String value) {
    return 'चीनी ${value}g';
  }

  @override
  String myDayChipSalt(String value) {
    return 'नमक ${value}mg';
  }

  @override
  String myDayChipFat(String value) {
    return 'वसा ${value}g';
  }

  @override
  String get myDayNothingAddedYet => 'अभी कुछ नहीं जोड़ा गया';

  @override
  String get myDayEmptyBody =>
      'आज जो आपने खाया उसे जोड़ें और फ़ूडलेंस उसे एक दिन की मात्रा के विरुद्ध जोड़ देगा।';

  @override
  String get myDayWhyBotherLabel => 'क्यों ज़रूरी है?';

  @override
  String get myDayWhyBotherTitle => 'एक पैक छोटा लगता है';

  @override
  String get myDayWhyBotherBody =>
      'दिन में चार स्नैक पूरे दिन का नमक या वसा पार कर सकते हैं, बिना किसी एक पैक का बुरा लगे।';

  @override
  String get myDayAddFirstItem => 'पहला आइटम जोड़ें';

  @override
  String get nutrientSugarLabel => 'चीनी (WHO फ्री-शुगर आधार)';

  @override
  String get nutrientSaltLabel => 'नमक (सोडियम)';

  @override
  String get nutrientHeavyFatLabel => 'हेवी फैट';

  @override
  String get formSpoons => 'चम्मच में नापा जाता है';

  @override
  String get formGlasses => 'गिलास में नापा जाता है';

  @override
  String get formKatoris => 'कटोरी में नापा जाता है';

  @override
  String get formPacketsDry => 'पैकेट गिने जाते हैं · सूखा वज़न';

  @override
  String formBiscuits(String grams) {
    return 'बिस्कुट गिने जाते हैं (~${grams}g प्रत्येक)';
  }

  @override
  String formSachets(String grams) {
    return 'सैशे गिने जाते हैं (${grams}g प्रत्येक)';
  }

  @override
  String formConcentrate(String dose, String makes) {
    return 'केवल सिरप — ${dose}ml से ${makes}ml का गिलास बनता है';
  }

  @override
  String formServing(String grams) {
    return 'लेबल सर्विंग ${grams}g';
  }

  @override
  String get caveatCook =>
      'जैसा बिकता है, सूखा वज़न। पकाते समय डाला गया तेल, मक्खन या सब्ज़ियां लेबल पर नहीं होतीं, इसलिए गिनी नहीं जातीं।';

  @override
  String get caveatConcentrate =>
      'केवल सिरप। हम आपके डाले गए सिरप को गिनते हैं, पानी को नहीं।';

  @override
  String caveatPiece(String grams) {
    return '~${grams}g प्रति बिस्कुट। टुकड़े गिनना ग्राम अनुमान लगाने से ज़्यादा सही है।';
  }

  @override
  String get todayNutritionLabel => 'आज का सेवन';

  @override
  String get actionSave => 'सहेजें';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते $name 👋';
  }

  @override
  String get homeLocation => 'सूरत, गुजरात';

  @override
  String get scanCtaTitle => 'प्रोडक्ट स्कैन करें';

  @override
  String get scanCtaSubtitle => 'बारकोड या फ़ोटो — कुछ सेकंड लगते हैं';

  @override
  String get scanCtaSemantics =>
      'प्रोडक्ट स्कैन करें, इस बिल्ड में उपलब्ध नहीं';

  @override
  String get statScansWeekLabel => 'इस हफ़्ते स्कैन';

  @override
  String get statFlagsLabel => 'पकड़े गए फ़्लैग';

  @override
  String get statLanguagesLabel => 'इस्तेमाल की गई भाषाएँ';

  @override
  String get recentScansLabel => 'हाल के स्कैन';

  @override
  String flagsPill(int count) {
    return '$count फ़्लैग';
  }

  @override
  String get clearPill => 'ठीक';

  @override
  String get scanUnavailable => 'इस बिल्ड में अभी स्कैनिंग उपलब्ध नहीं है।';

  @override
  String get recentScanUnavailable =>
      'इस बिल्ड में स्कैन परिणाम अभी उपलब्ध नहीं हैं।';

  @override
  String get homeEmptyTitle => 'अभी कोई हाल का स्कैन नहीं';

  @override
  String get homeEmptySubtitle => 'स्कैन किए गए प्रोडक्ट यहाँ दिखेंगे।';

  @override
  String get homeError => 'होम स्क्रीन लोड नहीं हो सकी।';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String get historyEmptyTitle => 'अभी कोई स्कैन नहीं';

  @override
  String get historyEmptySubtitle => 'आपके स्कैन किए गए प्रोडक्ट यहाँ दिखेंगे।';

  @override
  String get historyError => 'आपका इतिहास लोड नहीं हो सका।';

  @override
  String get demoDataBadge => 'डेमो डेटा';

  @override
  String labelToday(String time) {
    return 'आज, $time';
  }

  @override
  String labelYesterday(String time) {
    return 'कल, $time';
  }

  @override
  String labelDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileError => 'आपका प्रोफ़ाइल लोड नहीं हो सका।';

  @override
  String get profileDemoBadge => 'डेमो प्रोफ़ाइल';

  @override
  String get preferencesSection => 'प्राथमिकताएँ';

  @override
  String get languageRowLabel => 'भाषा';

  @override
  String get healthFlagsRowLabel => 'हेल्थ फ़्लैग';

  @override
  String get onThisDevice => 'इस डिवाइस पर';

  @override
  String get noFlagsSet => 'कोई सेट नहीं';

  @override
  String get healthFlagsSheetTitle => 'हेल्थ फ़्लैग';

  @override
  String get aboutSection => 'ऐप के बारे में';

  @override
  String get disclaimerText =>
      'हर आँकड़ा लेबल से पढ़ा जाता है। FoodLens चिकित्सकीय सलाह नहीं देता।';

  @override
  String get appVersionLabel => 'ऐप संस्करण';

  @override
  String get signOutTitle => 'साइन आउट करें?';

  @override
  String get signOutMessage =>
      'आप साइन-इन स्क्रीन पर वापस जाएँगे। आपकी भाषा और फ़्लैग इस डिवाइस पर रहेंगे।';

  @override
  String get errorGeneric => 'कुछ गड़बड़ हो गई।';

  @override
  String get notFoundTitle => 'पेज नहीं मिला';

  @override
  String get loadingLabel => 'लोड हो रहा है…';

  @override
  String get a11yLanguageSwitcher => 'भाषा चुनें';

  @override
  String get a11yBack => 'वापस जाएँ';

  @override
  String get a11yOpenLanguage => 'भाषा बदलें';

  @override
  String get a11yEditHealthFlags => 'हेल्थ फ़्लैग बदलें';
}
