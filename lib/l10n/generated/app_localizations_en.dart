// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FoodLens';

  @override
  String get appTagline =>
      'Scan any packaged food label and see exactly what\'s printed on it — in your language.';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionSkipForNow => 'Skip for now';

  @override
  String get actionBack => 'Back';

  @override
  String get actionClose => 'Close';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get phonePrefix => '+91';

  @override
  String get loginTitle => 'Enter your mobile number';

  @override
  String get loginSubtitle =>
      'We\'ll send a one-time code to verify it\'s you.';

  @override
  String get mobileNumberLabel => 'Mobile number';

  @override
  String get phoneHint => 'Please enter your number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get termsCaption =>
      'By continuing, you agree to FoodLens\' Terms and Privacy Policy.';

  @override
  String get demoSignInNotice =>
      'Demo sign-in — no SMS is sent. The code appears on the next screen.';

  @override
  String get phoneRequiredError => 'Mobile number is required';

  @override
  String get phoneInvalidError => 'Enter a valid 10-digit mobile number';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 6-digit code for $phone';
  }

  @override
  String otpDemoNotice(String code) {
    return 'Demo mode — no SMS was sent. Use code $code.';
  }

  @override
  String get otpVerify => 'Verify & continue';

  @override
  String get otpVerifying => 'Verifying…';

  @override
  String otpResendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get otpResendReady => 'Resend code';

  @override
  String get otpResendLimitReached =>
      'You\'ve reached the resend limit for this demo session.';

  @override
  String otpResent(String code) {
    return 'New demo code ready — use $code.';
  }

  @override
  String get otpIncompleteError => 'Enter all 6 digits';

  @override
  String get otpMismatchError => 'That code didn\'t match. Try again.';

  @override
  String get otpTooManyAttemptsError =>
      'Too many attempts. Restart the demo sign-in.';

  @override
  String get setupTitle => 'A couple of quick things';

  @override
  String get preferredLanguageLabel => 'Preferred language';

  @override
  String get flagQuestionLabel => 'Anything we should flag for, if present?';

  @override
  String get flagNote =>
      'Only changes which flags we surface first — never what\'s printed on the label.';

  @override
  String get flagDiabetes => 'Diabetes';

  @override
  String get flagBloodPressure => 'Blood pressure';

  @override
  String get flagCholesterol => 'Cholesterol';

  @override
  String get flagPregnancy => 'Pregnancy';

  @override
  String get flagNoneOfThese => 'None of these';

  @override
  String get termsTitle => 'Terms & Conditions';

  @override
  String get termsIntro =>
      'Before you continue, please read these terms for FoodLens.';

  @override
  String get termsAiHeading => 'AI-generated results';

  @override
  String get termsAiBody =>
      'All data and product scan results in FoodLens are AI-generated.';

  @override
  String get termsVerifyHeading => 'Verify important data';

  @override
  String get termsVerifyBody =>
      'Please properly verify any important information — such as allergens, nutrition values or health-related details — against the printed product label, or with a qualified professional, before relying on it.';

  @override
  String get termsHealthHeading => 'Health readings only';

  @override
  String get termsHealthBody =>
      'Our motto is only to provide AI-generated health readings for information. FoodLens does not intend to judge any brand as good or bad for health, and nothing here is medical advice.';

  @override
  String get termsAgreeLabel =>
      'I have read and understood the above, and I agree.';

  @override
  String get termsNext => 'Next';

  @override
  String get nameTitle => 'What\'s your name?';

  @override
  String get nameSubtitle => 'We\'ll use it to greet you inside the app.';

  @override
  String get nameLabel => 'Your name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get nameRequiredError => 'Please enter your name';

  @override
  String get languageScreenTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get languageSwitcherLabel => 'Language';

  @override
  String get navHome => 'Home';

  @override
  String get navMyDay => 'My Day';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get myDayTitle => 'My Day';

  @override
  String get myDayEmptyTitle => 'Nothing here yet';

  @override
  String get myDayEmptySubtitle => 'Your daily highlights will show up here.';

  @override
  String get myDayError => 'Could not load My Day. Please try again.';

  @override
  String get myDayPickTitle => 'Add to today';

  @override
  String get myDayPickSubtitle => 'Tap everything you ate today';

  @override
  String get myDayRecentScansLabel => 'Your recent scans';

  @override
  String get myDayPickNote =>
      'Only things you have scanned show up here. Scan a new pack to add it to this list.';

  @override
  String get myDayParseAdd => 'Parse & add to list';

  @override
  String get myDayNothingSelected => 'Select at least one item to continue.';

  @override
  String get myDayAmountTitle => 'How much?';

  @override
  String get myDayAmountSubtitle =>
      'Answer the way you\'d say it — spoons, glasses, katoris';

  @override
  String get myDayAmountNote =>
      'Nobody weighs snacks. Pick the measure you actually used. FoodLens converts it to grams underneath using each product\'s own density.';

  @override
  String get myDayEditQuantity => 'Edit quantity';

  @override
  String myDayGramsCounted(String grams) {
    return '$grams g counted';
  }

  @override
  String get myDayQuantityInvalid => 'Enter a valid amount greater than zero.';

  @override
  String get myDayQuantityTooHigh => 'Amount cannot exceed the full pack size.';

  @override
  String get myDayCalculate => 'Calculate My Day';

  @override
  String get myDayCalculating => 'Calculating…';

  @override
  String myDaySummarySubtitle(int count) {
    return '$count items · today vs your daily limits';
  }

  @override
  String get myDayAgainstLimitLabel => 'Today against the daily limit';

  @override
  String get myDayDailyLimit => 'Daily limit';

  @override
  String myDayRemaining(String amount) {
    return '$amount left';
  }

  @override
  String myDayOverBy(String amount) {
    return '$amount over';
  }

  @override
  String get myDayWhatMadeItUp => 'What made it up';

  @override
  String get myDayHoneyNote =>
      'Honey corrected. Your figures had honey at 0g sugar. WHO counts honey as free sugar (~82g per 100g), so it is included here — that is what pushes sugar over.';

  @override
  String get myDaySourceNote =>
      'Every figure is per-100g × grams eaten ÷ 100. Limits are WHO adult references, not FSSAI limits.';

  @override
  String get myDayAddAnother => 'Add Another Item';

  @override
  String get myDayGoHome => 'Go to Home';

  @override
  String myDayRemoveItem(String name) {
    return 'Remove $name';
  }

  @override
  String get myDaySaveError =>
      'Could not save today\'s entries. Please try again.';

  @override
  String myDayChipSugar(String value) {
    return 'sugar ${value}g';
  }

  @override
  String myDayChipSalt(String value) {
    return 'salt ${value}mg';
  }

  @override
  String myDayChipFat(String value) {
    return 'fat ${value}g';
  }

  @override
  String get myDayNothingAddedYet => 'Nothing added yet';

  @override
  String get myDayEmptyBody =>
      'Add what you ate today and FoodLens adds it up against one day\'s amount.';

  @override
  String get myDayWhyBotherLabel => 'Why bother?';

  @override
  String get myDayWhyBotherTitle => 'One pack looks small';

  @override
  String get myDayWhyBotherBody =>
      'Four snacks in a day can pass a whole day\'s salt or fat without any single pack looking bad.';

  @override
  String get myDayAddFirstItem => 'Add my first item';

  @override
  String get nutrientSugarLabel => 'Sugar (WHO free-sugar basis)';

  @override
  String get nutrientSaltLabel => 'Salt (sodium)';

  @override
  String get nutrientHeavyFatLabel => 'Heavy fat';

  @override
  String get formSpoons => 'measured in spoons';

  @override
  String get formGlasses => 'measured in glasses';

  @override
  String get formKatoris => 'measured in katoris';

  @override
  String get formPacketsDry => 'counted in packets · dry weight';

  @override
  String formBiscuits(String grams) {
    return 'counted in biscuits (~${grams}g each)';
  }

  @override
  String formSachets(String grams) {
    return 'counted in sachets (${grams}g each)';
  }

  @override
  String formConcentrate(String dose, String makes) {
    return 'syrup only — ${dose}ml makes a ${makes}ml glass';
  }

  @override
  String formServing(String grams) {
    return 'label serving ${grams}g';
  }

  @override
  String get caveatCook =>
      'Dry weight, as sold. Oil, butter or vegetables you add while cooking are not on the label, so they are not counted here.';

  @override
  String get caveatConcentrate =>
      'Syrup only. We count the syrup you pour, not the water you add.';

  @override
  String caveatPiece(String grams) {
    return '~${grams}g per biscuit. Counting pieces is closer to the truth than guessing grams.';
  }

  @override
  String get todayNutritionLabel => 'Today\'s intake';

  @override
  String get actionSave => 'Save';

  @override
  String homeGreeting(String name) {
    return 'Hi $name 👋';
  }

  @override
  String get homeLocation => 'Surat, Gujarat';

  @override
  String get scanCtaTitle => 'Scan a product';

  @override
  String get scanCtaSubtitle => 'Barcode or photo — takes a few seconds';

  @override
  String get scanCtaSemantics => 'Scan a product, not available in this build';

  @override
  String get statScansWeekLabel => 'Scans this week';

  @override
  String get statFlagsLabel => 'Flags caught';

  @override
  String get statLanguagesLabel => 'Languages used';

  @override
  String get recentScansLabel => 'Recent scans';

  @override
  String flagsPill(int count) {
    return '$count flags';
  }

  @override
  String get clearPill => 'Clear';

  @override
  String get scanUnavailable => 'Scanning isn\'t available in this build yet.';

  @override
  String get recentScanUnavailable =>
      'Scan results aren\'t available in this build yet.';

  @override
  String get homeEmptyTitle => 'No recent scans yet';

  @override
  String get homeEmptySubtitle => 'Products you scan will show up here.';

  @override
  String get homeError => 'Couldn\'t load the home screen.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmptyTitle => 'No scans yet';

  @override
  String get historyEmptySubtitle => 'Products you scan will show up here.';

  @override
  String get historyError => 'Couldn\'t load your history.';

  @override
  String get demoDataBadge => 'Demo data';

  @override
  String labelToday(String time) {
    return 'Today, $time';
  }

  @override
  String labelYesterday(String time) {
    return 'Yesterday, $time';
  }

  @override
  String labelDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileError => 'Couldn\'t load your profile.';

  @override
  String get profileDemoBadge => 'Demo profile';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get languageRowLabel => 'Language';

  @override
  String get healthFlagsRowLabel => 'Health flags';

  @override
  String get onThisDevice => 'On this device';

  @override
  String get noFlagsSet => 'None set';

  @override
  String get healthFlagsSheetTitle => 'Health flags';

  @override
  String get aboutSection => 'About';

  @override
  String get disclaimerText =>
      'Every figure is read from the printed label. FoodLens does not give medical advice.';

  @override
  String get appVersionLabel => 'App version';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutMessage =>
      'You\'ll return to the sign-in screen. Your language and flags stay on this device.';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get a11yLanguageSwitcher => 'Choose language';

  @override
  String get a11yBack => 'Go back';

  @override
  String get a11yOpenLanguage => 'Change language';

  @override
  String get a11yEditHealthFlags => 'Edit health flags';
}
