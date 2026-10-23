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
