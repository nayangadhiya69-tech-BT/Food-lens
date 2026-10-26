// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'FoodLens';

  @override
  String get appTagline =>
      'કોઈપણ પેકેજ્ડ ફૂડ લેબલ સ્કેન કરો અને તેના પર શું છપાયું છે — તમારી ભાષામાં જુઓ.';

  @override
  String get actionRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get actionCancel => 'રદ કરો';

  @override
  String get actionContinue => 'ચાલુ રાખો';

  @override
  String get actionSkipForNow => 'હાલ મૂકી દો';

  @override
  String get actionBack => 'પાછા';

  @override
  String get actionClose => 'બંધ કરો';

  @override
  String get actionSignOut => 'સાઇન આઉટ';

  @override
  String get phonePrefix => '+91';

  @override
  String get loginTitle => 'તમારો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get loginSubtitle => 'તમારી ચકાસણી માટે અમે એક વખતનો કોડ મોકલીશું.';

  @override
  String get mobileNumberLabel => 'મોબાઇલ નંબર';

  @override
  String get phoneHint => 'કૃપા કરીને તમારો નંબર દાખલ કરો';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get termsCaption =>
      'ચાલુ રાખીને, તમે FoodLensની શરતો અને ગોપનીયતા નીતિ સંમત થાઓ છો.';

  @override
  String get demoSignInNotice =>
      'ડેમો સાઇન-ઇન — કોઈ SMS મોકલાતો નથી. કોડ આગળની સ્ક્રીન પર મળશે.';

  @override
  String get phoneRequiredError => 'મોબાઇલ નંબર જરૂરી છે';

  @override
  String get phoneInvalidError => 'માન્ય 10-અંકનો નંબર દાખલ કરો';

  @override
  String get otpTitle => 'તમારો નંબર ચકાસો';

  @override
  String otpSubtitle(String phone) {
    return '$phone માટે 6-અંકનો કોડ દાખલ કરો';
  }

  @override
  String otpDemoNotice(String code) {
    return 'ડેમો મોડ — કોઈ SMS મોકલાયો નથી. કોડ $code વાપરો.';
  }

  @override
  String get otpVerify => 'ચકાસો અને ચાલુ રાખો';

  @override
  String get otpVerifying => 'ચકાસી રહ્યા છીએ…';

  @override
  String otpResendIn(String time) {
    return '$time માં કોડ ફરી મોકલો';
  }

  @override
  String get otpResendReady => 'કોડ ફરી મોકલો';

  @override
  String get otpResendLimitReached =>
      'આ ડેમો સત્ર માટે ફરી મોકલવાની મર્યાદા પૂરી થઈ ગઈ છે.';

  @override
  String otpResent(String code) {
    return 'નવો ડેમો કોડ તૈયાર છે — $code વાપરો.';
  }

  @override
  String get otpIncompleteError => 'બધા 6 અંક દાખલ કરો';

  @override
  String get otpMismatchError => 'કોડ મેળ ખાતો નથી. ફરી પ્રયાસ કરો.';

  @override
  String get otpTooManyAttemptsError =>
      'ઘણા પ્રયાસો થયા. ડેમો સાઇન-ઇન ફરી શરૂ કરો.';

  @override
  String get setupTitle => 'બે-ચાર નાની વાતો';

  @override
  String get preferredLanguageLabel => 'પસંદગીની ભાષા';

  @override
  String get flagQuestionLabel => 'હાજર હોય તો શું ધ્યાન રાખવું?';

  @override
  String get flagNote =>
      'માત્ર એ નક્કી કરે છે કે કયા ફ્લેગ પહેલા દેખાશે — લેબલ પર શું છપાયું છે તે બદલાતું નથી.';

  @override
  String get flagDiabetes => 'મધુપ્રમેહ';

  @override
  String get flagBloodPressure => 'લોહીનું દબાણ';

  @override
  String get flagCholesterol => 'કોલેસ્ટ્રોલ';

  @override
  String get flagPregnancy => 'ગર્ભાવસ્થા';

  @override
  String get flagJain => 'જૈન';

  @override
  String get flagSwaminarayan => 'સ્વામીનારાયણ';

  @override
  String get flagNoneOfThese => 'આમાંથી કંઈ નહીં';

  @override
  String get termsTitle => 'નિયમો અને શરતો';

  @override
  String get termsIntro =>
      'આગળ વધતા પહેલાં કૃપા કરીને FoodLens ની આ શરતો વાંચો.';

  @override
  String get termsAiHeading => 'AI-જનિત પરિણામો';

  @override
  String get termsAiBody =>
      'FoodLens માં તમામ ડેટા અને પ્રોડક્ટ સ્કેન પરિણામો AI-જનિત છે.';

  @override
  String get termsVerifyHeading => 'મહત્વનો ડેટા ચકાસો';

  @override
  String get termsVerifyBody =>
      'ભરોસો કરતા પહેલાં કોઈ પણ મહત્વની માહિતી — જેમ કે એલર્જન, પોષણ મૂલ્યો કે આરોગ્ય સંબંધિત વિગતો — પ્રોડક્ટના પ્રિન્ટેડ લેબલ અથવા કોઈ લાયક વ્યાવસાયિક સાથે ચકાસો.';

  @override
  String get termsHealthHeading => 'ફક્ત આરોગ્ય રીડિંગ';

  @override
  String get termsHealthBody =>
      'અમારો ઉદ્દેશ ફક્ત માહિતી માટે AI-જનિત આરોગ્ય રીડિંગ આપવાનો છે. FoodLens કોઈ બ્રાન્ડને આરોગ્ય માટે સારી કે ખરાબ ગણાવવાનું ઇરાદો ધરાવતું નથી, અને અહીં કંઈપણ તબીબી સલાહ નથી.';

  @override
  String get termsAgreeLabel =>
      'મેં ઉપરોક્ત વાંચ્યું અને સમજ્યું છે, અને હું સંમત છું.';

  @override
  String get termsNext => 'આગળ વધો';

  @override
  String get nameTitle => 'તમારું નામ શું છે?';

  @override
  String get nameSubtitle =>
      'અમે તેનો ઉપયોગ એપમાં તમારું અભિવાદન કરવા માટે કરીશું.';

  @override
  String get nameLabel => 'તમારું નામ';

  @override
  String get nameHint => 'તમારું નામ દાખલ કરો';

  @override
  String get nameRequiredError => 'કૃપા કરીને તમારું નામ દાખલ કરો';

  @override
  String get languageScreenTitle => 'ભાષા';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get languageSwitcherLabel => 'ભાષા પસંદ કરો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navMyDay => 'મારો દિવસ';

  @override
  String get navHistory => 'ઇતિહાસ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get myDayTitle => 'મારો દિવસ';

  @override
  String get myDayEmptyTitle => 'હજી કંઈ નથી';

  @override
  String get myDayEmptySubtitle => 'તમારી દૈનિક હાઇલાઇટ્સ અહીં દેખાશે.';

  @override
  String get myDayError =>
      'મારો દિવસ લોડ થઈ શક્યો નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get myDayPickTitle => 'આજે શું ખાધું';

  @override
  String get myDayPickSubtitle => 'આજે જે કંઈ ખાધું તે પસંદ કરો';

  @override
  String get myDayRecentScansLabel => 'તમારા તાજેતરના સ્કેન';

  @override
  String get myDayPickNote =>
      'અહીં ફક્ત એ જ વસ્તુઓ દેખાય છે જે તમે સ્કેન કરી છે. આ યાદીમાં ઉમેરવા માટે નવો પેક સ્કેન કરો.';

  @override
  String get myDayParseAdd => 'પાર્સ કરો અને યાદીમાં ઉમેરો';

  @override
  String get myDayNothingSelected =>
      'આગળ વધવા માટે ઓછામાં ઓછી એક વસ્તુ પસંદ કરો.';

  @override
  String get myDayAmountTitle => 'કેટલું લીધું?';

  @override
  String get myDayAmountSubtitle => 'જેમ તમે બોલો તેમ કહો — ચમચી, ગ્લાસ, કટોરી';

  @override
  String get myDayAmountNote =>
      'કોઈ સ્નેક તોલતું નથી. તમે સાચેથી વાપરેલું માપ પસંદ કરો. ફૂડલેન્સ દરેક પ્રોડક્ટની પોતાની ઘનતાથી તેને ગ્રામમાં બદલી દે છે.';

  @override
  String get myDayEditQuantity => 'જથ્થો સંપાદિત કરો';

  @override
  String myDayGramsCounted(String grams) {
    return '$grams ગ્રામ ગણ્યા';
  }

  @override
  String get myDayQuantityInvalid => 'શૂન્યથી વધુ માન્ય જથ્થો દાખલ કરો.';

  @override
  String get myDayQuantityTooHigh => 'જથ્થો સંપૂર્ણ પેકથી વધી શકતો નથી.';

  @override
  String get myDayCalculate => 'મારો દિવસ ગણો';

  @override
  String get myDayCalculating => 'ગણતરી ચાલુ છે…';

  @override
  String myDaySummarySubtitle(int count) {
    return '$count વસ્તુઓ · આજે તમારી દૈનિક મર્યાદાઓ સામે';
  }

  @override
  String get myDayAgainstLimitLabel => 'આજે દૈનિક મર્યાદા સામે';

  @override
  String get myDayDailyLimit => 'દૈનિક મર્યાદા';

  @override
  String myDayRemaining(String amount) {
    return '$amount બાકી';
  }

  @override
  String myDayOverBy(String amount) {
    return '$amount વધારે';
  }

  @override
  String get myDayWhatMadeItUp => 'તેમાં શું સામેલ છે';

  @override
  String get myDayHoneyNote =>
      'મધ સુધારેલ છે. તમારા આંકડામાં મધ 0g ખાંડ હતો. WHO મધને ફ્રી ખાંડ (~82g પ્રતિ 100g) ગણે છે, તેથી અહીં સામેલ છે — આથી જ ખાંડ મર્યાદા વટાવે છે.';

  @override
  String get myDaySourceNote =>
      'દરેક આંકડો પ્રતિ-100g × ખાયેલા ગ્રામ ÷ 100 છે. મર્યાદાઓ WHO પુખ્ત વય સંદર્ભો છે, FSSAI મર્યાદાઓ નહીં.';

  @override
  String get myDayAddAnother => 'બીજી વસ્તુ ઉમેરો';

  @override
  String get myDayGoHome => 'હોમ પર જાઓ';

  @override
  String myDayRemoveItem(String name) {
    return '$name દૂર કરો';
  }

  @override
  String get myDaySaveError =>
      'આજની નોંધો સાચવી શકાઈ નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String myDayChipSugar(String value) {
    return 'ખાંડ ${value}g';
  }

  @override
  String myDayChipSalt(String value) {
    return 'મીઠું ${value}mg';
  }

  @override
  String myDayChipFat(String value) {
    return 'ચરબી ${value}g';
  }

  @override
  String get myDayNothingAddedYet => 'હજી કંઈ ઉમેર્યું નથી';

  @override
  String get myDayEmptyBody =>
      'આજે તમે જે ખાધું તે ઉમેરો અને ફૂડલેન્સ તેને એક દિવસના જથ્થા સામે ઉમેરશે.';

  @override
  String get myDayWhyBotherLabel => 'શા માટે જરૂરી છે?';

  @override
  String get myDayWhyBotherTitle => 'એક પેક નાનો લાગે છે';

  @override
  String get myDayWhyBotherBody =>
      'દિવસમાં ચાર સ્નેક આખા દિવસનું મીઠું કે ચરબી પાર કરી શકે છે, વગર કોઈ એક પેક ખરાબ લાગ્યા.';

  @override
  String get myDayAddFirstItem => 'પહેલી વસ્તુ ઉમેરો';

  @override
  String get nutrientSugarLabel => 'ખાંડ (WHO ફ્રી-શુગર આધાર)';

  @override
  String get nutrientSaltLabel => 'મીઠું (સોડિયમ)';

  @override
  String get nutrientHeavyFatLabel => 'હેવી ફેટ';

  @override
  String get formSpoons => 'ચમચીમાં માપવામાં આવે છે';

  @override
  String get formGlasses => 'ગ્લાસમાં માપવામાં આવે છે';

  @override
  String get formKatoris => 'કટોરીમાં માપવામાં આવે છે';

  @override
  String get formPacketsDry => 'પેકેટ ગણવામાં આવે છે · સૂકું વજન';

  @override
  String formBiscuits(String grams) {
    return 'બિસ્કિટ ગણવામાં આવે છે (~${grams}g દીઠ)';
  }

  @override
  String formSachets(String grams) {
    return 'સેશે ગણવામાં આવે છે (${grams}g દીઠ)';
  }

  @override
  String formConcentrate(String dose, String makes) {
    return 'ફક્ત સિરપ — ${dose}ml થી ${makes}ml નો ગ્લાસ બને છે';
  }

  @override
  String formServing(String grams) {
    return 'લેબલ સર્વિંગ ${grams}g';
  }

  @override
  String get caveatCook =>
      'જેમ વેચાય છે, સૂકું વજન. રાંધતી વખતે ઉમેરેલું તેલ, માખણ કે શાકભાજી લેબલ પર હોતા નથી, તેથી ગણાતા નથી.';

  @override
  String get caveatConcentrate =>
      'ફક્ત સિરપ. અમે તમે રેડેલા સિરપને ગણીએ છીએ, પાણીને નહીં.';

  @override
  String caveatPiece(String grams) {
    return '~${grams}g દીઠ બિસ્કિટ. ટુકડા ગણવા એ ગ્રામ અનુમાન કરતાં વધુ સાચું છે.';
  }

  @override
  String get todayNutritionLabel => 'આજનું સેવન';

  @override
  String get actionSave => 'સાચવો';

  @override
  String homeGreeting(String name) {
    return 'નમસ્તે $name 👋';
  }

  @override
  String get homeLocation => 'સુરત, ગુજરાત';

  @override
  String get scanCtaTitle => 'પ્રોડક્ટ સ્કેન કરો';

  @override
  String get scanCtaSubtitle => 'બારકોડ અથવા ફોટો — થોડી સેકંડ લાગે છે';

  @override
  String get scanCtaSemantics => 'પ્રોડક્ટ સ્કેન કરો';

  @override
  String get statScansWeekLabel => 'આ અઠવાડિયે સ્કેન';

  @override
  String get statFlagsLabel => 'પકડાયેલા ફ્લેગ';

  @override
  String get statLanguagesLabel => 'વપરાયેલી ભાષાઓ';

  @override
  String get recentScansLabel => 'તાજેતરના સ્કેન';

  @override
  String flagsPill(int count) {
    return '$count ફ્લેગ';
  }

  @override
  String get clearPill => 'ઠીક';

  @override
  String get scanUnavailable => 'આ બિલ્ડમાં સ્કેનિંગ હજુ ઉપલબ્ધ નથી.';

  @override
  String get recentScanUnavailable =>
      'આ બિલ્ડમાં સ્કેન પરિણામો હજુ ઉપલબ્ધ નથી.';

  @override
  String get homeEmptyTitle => 'હજી કોઈ તાજેતરનું સ્કેન નથી';

  @override
  String get homeEmptySubtitle => 'તમે સ્કેન કરેલા પ્રોડક્ટ અહીં દેખાશે.';

  @override
  String get homeError => 'હોમ સ્ક્રીન લોડ થઈ શકી નથી.';

  @override
  String get scanModeTitle => 'તમે કેવી રીતે સ્કેન કરવા માંગો છો?';

  @override
  String get scanModeBarcodeTitle => 'બારકોડ સ્કેન કરો';

  @override
  String get scanModeBarcodeBody =>
      'સૌથી ઝડપી વિકલ્પ — અમારા ડેટાબેસમાં પહેલેથી હોય તે કોઈપણ પેકેજ્ડ પ્રોડક્ટ માટે કામ કરે છે.';

  @override
  String get scanModePhotoTitle => 'ફોટો લો';

  @override
  String get scanModePhotoBody =>
      'બારકોડ વગરના અથવા હજુ ડેટાબેસમાં ન હોય તેવા પ્રોડક્ટ માટે. બે ફોટા: પોષણ પેનલ અને ઘટકો.';

  @override
  String get scanModeSemantics => 'સ્કેન કરવાની રીત પસંદ કરો';

  @override
  String get scanBarcodeHint => 'બારકોડને ફ્રેમની અંદર ગોઠવો';

  @override
  String get scanNoBarcode => 'બારકોડ નથી?';

  @override
  String get scanSwitchToPhoto => 'ફોટો મોડમાં બદલો';

  @override
  String get scanPhotoHint1 => 'ફોટો 1 માંથી 2 — પોષણ પેનલ';

  @override
  String get scanPhotoHint2 => 'ફોટો 2 માંથી 2 — ઘટકો';

  @override
  String get scanFlashLabel => 'ફ્લેશ ચાલૂ અથવા બંધ કરો';

  @override
  String get scanGalleryUnavailable =>
      'ગેલેરીમાંથી ફોટો પસંદ કરવો આ બિલ્ડમાં હજુ ઉપલબ્ધ નથી.';

  @override
  String get scanCameraUnavailableTitle => 'કેમેરા ઉપલબ્ધ નથી';

  @override
  String get scanCameraUnavailableBody =>
      'વાસ્તવિક સ્કેન માટે સેટિંગ્સમાં કેમેરા એક્સેસ સક્ષમ કરો — અથવા હમણાં ડેમો સ્કેન સાથે ચાલુ રાખો.';

  @override
  String get scanCaptureFallback =>
      'ફોટો સંગ્રહી શકાયો નથી — ડેમો સ્કેન સાથે ચાલુ રાખીએ છીએ.';

  @override
  String get scanProcessingTitle => 'લેબલ વંચાઈ રહ્યું છે…';

  @override
  String get scanStepBarcodeMatched => 'બારકોડ FSSAI ડેટાબેસ સાથે મેળ ગયો';

  @override
  String get scanStepPhotosReceived => 'લેબલના ફોટા મળ્યા';

  @override
  String get scanStepNutrition => 'પોષણ પેનલ કાઢવામાં આવ્યું';

  @override
  String get scanStepAdditives => 'એડિટિવ્સ અને એલર્જન તપાસી રહ્યા છીએ';

  @override
  String get scanStepScoring => 'WHO / ICMR-NIN મર્યાદાઓ સામે સ્કોરિંગ';

  @override
  String get scanError => 'આ લેબલ વંચાયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get scanStatSodiumLabel => '80 g પેક પર સોડિયમ';

  @override
  String get scanStatConditionLabel => 'ફ્લેગ થયેલી સ્થિતિ';

  @override
  String get scanStatAdditivesLabel => 'એડિટિવ્સ';

  @override
  String get scanStatAllergensLabel => 'એલર્જન';

  @override
  String get scanStatScoreLabel => 'લેબલ રીડ સ્કોર';

  @override
  String scanBannerTitle(int count) {
    return 'આ લેબલ પર $count વસ્તુઓ ફ્લેગ છે';
  }

  @override
  String get scanDepthLabel => 'ઊંડાણપૂર્વક ડિકોડ';

  @override
  String get scanLabelFlagsLabel => 'આ લેબલ પરના ફ્લેગ';

  @override
  String get scanFullDecode => 'સંપૂર્ણ લેબલ ડિકોડ જુઓ';

  @override
  String get fullDecodeUnavailable =>
      'સંપૂર્ણ લેબલ ડિકોડ આ બિલ્ડમાં હજુ ઉપલબ્ધ નથી.';

  @override
  String get shareUnavailable => 'શેર કરવું આ બિલ્ડમાં હજુ ઉપલબ્ધ નથી.';

  @override
  String get historyTitle => 'ઇતિહાસ';

  @override
  String get historyEmptyTitle => 'હજી કોઈ સ્કેન નથી';

  @override
  String get historyEmptySubtitle => 'તમે સ્કેન કરેલા પ્રોડક્ટ અહીં દેખાશે.';

  @override
  String get historyError => 'તમારો ઇતિહાસ લોડ થઈ શક્યો નથી.';

  @override
  String get demoDataBadge => 'ડેમો ડેટા';

  @override
  String labelToday(String time) {
    return 'આજે, $time';
  }

  @override
  String labelYesterday(String time) {
    return 'ગઈકાલે, $time';
  }

  @override
  String labelDaysAgo(int count) {
    return '$count દિવસ પહેલાં';
  }

  @override
  String get profileTitle => 'પ્રોફાઇલ';

  @override
  String get profileError => 'તમારું પ્રોફાઇલ લોડ થઈ શક્યું નથી.';

  @override
  String get profileDemoBadge => 'ડેમો પ્રોફાઇલ';

  @override
  String get preferencesSection => 'પસંદગીઓ';

  @override
  String get languageRowLabel => 'ભાષા';

  @override
  String get healthFlagsRowLabel => 'હેલ્થ ફ્લેગ';

  @override
  String get onThisDevice => 'આ ડિવાઇસ પર';

  @override
  String get noFlagsSet => 'કંઈ સેટ નથી';

  @override
  String get healthFlagsSheetTitle => 'હેલ્થ ફ્લેગ';

  @override
  String get aboutSection => 'એપ વિશે';

  @override
  String get disclaimerText =>
      'દરેક આંકડો લેબલમાંથી વંચાય છે. FoodLens તબીબી સલાહ આપતું નથી.';

  @override
  String get appVersionLabel => 'એપ સંસ્કરણ';

  @override
  String get signOutTitle => 'સાઇન આઉટ કરવું છે?';

  @override
  String get signOutMessage =>
      'તમે સાઇન-ઇન સ્ક્રીન પર પાછા જશો. તમારી ભાષા અને ફ્લેગ આ ડિવાઇસ પર રહેશે.';

  @override
  String get errorGeneric => 'કંઈક ખોટું થયું.';

  @override
  String get notFoundTitle => 'પેજ મળ્યું નથી';

  @override
  String get loadingLabel => 'લોડ થઈ રહ્યું છે…';

  @override
  String get a11yLanguageSwitcher => 'ભાષા પસંદ કરો';

  @override
  String get a11yBack => 'પાછા જાઓ';

  @override
  String get a11yOpenLanguage => 'ભાષા બદલો';

  @override
  String get a11yEditHealthFlags => 'હેલ્થ ફ્લેગ બદલો';
}
