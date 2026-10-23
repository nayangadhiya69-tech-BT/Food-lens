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
  String get scanCtaSemantics => 'પ્રોડક્ટ સ્કેન કરો, આ બિલ્ડમાં ઉપલબ્ધ નથી';

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
