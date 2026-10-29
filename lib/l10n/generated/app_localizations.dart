import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FoodLens'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Scan any packaged food label and see exactly what\'s printed on it — in your language.'**
  String get appTagline;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get actionSkipForNow;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @phonePrefix.
  ///
  /// In en, this message translates to:
  /// **'+91'**
  String get phonePrefix;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time code to verify it\'s you.'**
  String get loginSubtitle;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumberLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your number'**
  String get phoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @termsCaption.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to FoodLens\' Terms and Privacy Policy.'**
  String get termsCaption;

  /// No description provided for @demoSignInNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo sign-in — no SMS is sent. The code appears on the next screen.'**
  String get demoSignInNotice;

  /// No description provided for @phoneRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get phoneRequiredError;

  /// No description provided for @phoneInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get phoneInvalidError;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code for {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — no SMS was sent. Use code {code}.'**
  String otpDemoNotice(String code);

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get otpVerify;

  /// No description provided for @otpVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get otpVerifying;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String otpResendIn(String time);

  /// No description provided for @otpResendReady.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResendReady;

  /// No description provided for @otpResendLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the resend limit for this demo session.'**
  String get otpResendLimitReached;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'New demo code ready — use {code}.'**
  String otpResent(String code);

  /// No description provided for @otpIncompleteError.
  ///
  /// In en, this message translates to:
  /// **'Enter all 6 digits'**
  String get otpIncompleteError;

  /// No description provided for @otpMismatchError.
  ///
  /// In en, this message translates to:
  /// **'That code didn\'t match. Try again.'**
  String get otpMismatchError;

  /// No description provided for @otpTooManyAttemptsError.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Restart the demo sign-in.'**
  String get otpTooManyAttemptsError;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'A couple of quick things'**
  String get setupTitle;

  /// No description provided for @preferredLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Listen language'**
  String get preferredLanguageLabel;

  /// No description provided for @flagQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything we should flag for, if present?'**
  String get flagQuestionLabel;

  /// No description provided for @flagNote.
  ///
  /// In en, this message translates to:
  /// **'Only changes which flags we surface first — never what\'s printed on the label.'**
  String get flagNote;

  /// No description provided for @flagDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get flagDiabetes;

  /// No description provided for @flagBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get flagBloodPressure;

  /// No description provided for @flagCholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get flagCholesterol;

  /// No description provided for @flagPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get flagPregnancy;

  /// No description provided for @flagJain.
  ///
  /// In en, this message translates to:
  /// **'Jain'**
  String get flagJain;

  /// No description provided for @flagSwaminarayan.
  ///
  /// In en, this message translates to:
  /// **'Swaminarayan'**
  String get flagSwaminarayan;

  /// No description provided for @flagNoneOfThese.
  ///
  /// In en, this message translates to:
  /// **'None of these'**
  String get flagNoneOfThese;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'Before you continue, please read these terms for FoodLens.'**
  String get termsIntro;

  /// No description provided for @termsAiHeading.
  ///
  /// In en, this message translates to:
  /// **'AI-generated results'**
  String get termsAiHeading;

  /// No description provided for @termsAiBody.
  ///
  /// In en, this message translates to:
  /// **'All data and product scan results in FoodLens are AI-generated.'**
  String get termsAiBody;

  /// No description provided for @termsVerifyHeading.
  ///
  /// In en, this message translates to:
  /// **'Verify important data'**
  String get termsVerifyHeading;

  /// No description provided for @termsVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'Please properly verify any important information — such as allergens, nutrition values or health-related details — against the printed product label, or with a qualified professional, before relying on it.'**
  String get termsVerifyBody;

  /// No description provided for @termsHealthHeading.
  ///
  /// In en, this message translates to:
  /// **'Health readings only'**
  String get termsHealthHeading;

  /// No description provided for @termsHealthBody.
  ///
  /// In en, this message translates to:
  /// **'Our motto is only to provide AI-generated health readings for information. FoodLens does not intend to judge any brand as good or bad for health, and nothing here is medical advice.'**
  String get termsHealthBody;

  /// No description provided for @termsAgreeLabel.
  ///
  /// In en, this message translates to:
  /// **'I have read and understood the above, and I agree.'**
  String get termsAgreeLabel;

  /// No description provided for @termsNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get termsNext;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameTitle;

  /// No description provided for @nameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use it to greet you inside the app.'**
  String get nameSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequiredError;

  /// No description provided for @languageScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice language'**
  String get languageScreenTitle;

  /// No description provided for @languageVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Screen text always stays in English. Choose the language you want the Listen voiceover to speak in.'**
  String get languageVoiceNote;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageGujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get languageGujarati;

  /// No description provided for @languageSwitcherLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSwitcherLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMyDay.
  ///
  /// In en, this message translates to:
  /// **'My Day'**
  String get navMyDay;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @myDayTitle.
  ///
  /// In en, this message translates to:
  /// **'My Day'**
  String get myDayTitle;

  /// No description provided for @myDayEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get myDayEmptyTitle;

  /// No description provided for @myDayEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily highlights will show up here.'**
  String get myDayEmptySubtitle;

  /// No description provided for @myDayError.
  ///
  /// In en, this message translates to:
  /// **'Could not load My Day. Please try again.'**
  String get myDayError;

  /// No description provided for @myDayPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to today'**
  String get myDayPickTitle;

  /// No description provided for @myDayPickSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap everything you ate today'**
  String get myDayPickSubtitle;

  /// No description provided for @myDayRecentScansLabel.
  ///
  /// In en, this message translates to:
  /// **'Your recent scans'**
  String get myDayRecentScansLabel;

  /// No description provided for @myDayPickNote.
  ///
  /// In en, this message translates to:
  /// **'Only things you have scanned show up here. Scan a new pack to add it to this list.'**
  String get myDayPickNote;

  /// No description provided for @myDayParseAdd.
  ///
  /// In en, this message translates to:
  /// **'Parse & add to list'**
  String get myDayParseAdd;

  /// No description provided for @myDayNothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Select at least one item to continue.'**
  String get myDayNothingSelected;

  /// No description provided for @myDayAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'How much?'**
  String get myDayAmountTitle;

  /// No description provided for @myDayAmountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer the way you\'d say it — spoons, glasses, katoris'**
  String get myDayAmountSubtitle;

  /// No description provided for @myDayAmountNote.
  ///
  /// In en, this message translates to:
  /// **'Nobody weighs snacks. Pick the measure you actually used. FoodLens converts it to grams underneath using each product\'s own density.'**
  String get myDayAmountNote;

  /// No description provided for @myDayEditQuantity.
  ///
  /// In en, this message translates to:
  /// **'Edit quantity'**
  String get myDayEditQuantity;

  /// No description provided for @myDayGramsCounted.
  ///
  /// In en, this message translates to:
  /// **'{grams} g counted'**
  String myDayGramsCounted(String grams);

  /// No description provided for @myDayQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than zero.'**
  String get myDayQuantityInvalid;

  /// No description provided for @myDayQuantityTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed the full pack size.'**
  String get myDayQuantityTooHigh;

  /// No description provided for @myDayCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate My Day'**
  String get myDayCalculate;

  /// No description provided for @myDayCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get myDayCalculating;

  /// No description provided for @myDaySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} items · today vs your daily limits'**
  String myDaySummarySubtitle(int count);

  /// No description provided for @myDayAgainstLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Today against the daily limit'**
  String get myDayAgainstLimitLabel;

  /// No description provided for @myDayDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily limit'**
  String get myDayDailyLimit;

  /// No description provided for @myDayRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String myDayRemaining(String amount);

  /// No description provided for @myDayOverBy.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String myDayOverBy(String amount);

  /// No description provided for @myDayWhatMadeItUp.
  ///
  /// In en, this message translates to:
  /// **'What made it up'**
  String get myDayWhatMadeItUp;

  /// No description provided for @myDayHoneyNote.
  ///
  /// In en, this message translates to:
  /// **'Honey corrected. Your figures had honey at 0g sugar. WHO counts honey as free sugar (~82g per 100g), so it is included here — that is what pushes sugar over.'**
  String get myDayHoneyNote;

  /// No description provided for @myDaySourceNote.
  ///
  /// In en, this message translates to:
  /// **'Every figure is per-100g × grams eaten ÷ 100. Limits are WHO adult references, not FSSAI limits.'**
  String get myDaySourceNote;

  /// No description provided for @myDayAddAnother.
  ///
  /// In en, this message translates to:
  /// **'Add Another Item'**
  String get myDayAddAnother;

  /// No description provided for @myDayGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get myDayGoHome;

  /// No description provided for @myDayRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String myDayRemoveItem(String name);

  /// No description provided for @myDaySaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save today\'s entries. Please try again.'**
  String get myDaySaveError;

  /// No description provided for @myDayChipSugar.
  ///
  /// In en, this message translates to:
  /// **'sugar {value}g'**
  String myDayChipSugar(String value);

  /// No description provided for @myDayChipSalt.
  ///
  /// In en, this message translates to:
  /// **'salt {value}mg'**
  String myDayChipSalt(String value);

  /// No description provided for @myDayChipFat.
  ///
  /// In en, this message translates to:
  /// **'fat {value}g'**
  String myDayChipFat(String value);

  /// No description provided for @myDayNothingAddedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing added yet'**
  String get myDayNothingAddedYet;

  /// No description provided for @myDayEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add what you ate today and FoodLens adds it up against one day\'s amount.'**
  String get myDayEmptyBody;

  /// No description provided for @myDayWhyBotherLabel.
  ///
  /// In en, this message translates to:
  /// **'Why bother?'**
  String get myDayWhyBotherLabel;

  /// No description provided for @myDayWhyBotherTitle.
  ///
  /// In en, this message translates to:
  /// **'One pack looks small'**
  String get myDayWhyBotherTitle;

  /// No description provided for @myDayWhyBotherBody.
  ///
  /// In en, this message translates to:
  /// **'Four snacks in a day can pass a whole day\'s salt or fat without any single pack looking bad.'**
  String get myDayWhyBotherBody;

  /// No description provided for @myDayAddFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add my first item'**
  String get myDayAddFirstItem;

  /// No description provided for @nutrientSugarLabel.
  ///
  /// In en, this message translates to:
  /// **'Sugar (WHO free-sugar basis)'**
  String get nutrientSugarLabel;

  /// No description provided for @nutrientSaltLabel.
  ///
  /// In en, this message translates to:
  /// **'Salt (sodium)'**
  String get nutrientSaltLabel;

  /// No description provided for @nutrientHeavyFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Heavy fat'**
  String get nutrientHeavyFatLabel;

  /// No description provided for @formSpoons.
  ///
  /// In en, this message translates to:
  /// **'measured in spoons'**
  String get formSpoons;

  /// No description provided for @formGlasses.
  ///
  /// In en, this message translates to:
  /// **'measured in glasses'**
  String get formGlasses;

  /// No description provided for @formKatoris.
  ///
  /// In en, this message translates to:
  /// **'measured in katoris'**
  String get formKatoris;

  /// No description provided for @formPacketsDry.
  ///
  /// In en, this message translates to:
  /// **'counted in packets · dry weight'**
  String get formPacketsDry;

  /// No description provided for @formBiscuits.
  ///
  /// In en, this message translates to:
  /// **'counted in biscuits (~{grams}g each)'**
  String formBiscuits(String grams);

  /// No description provided for @formSachets.
  ///
  /// In en, this message translates to:
  /// **'counted in sachets ({grams}g each)'**
  String formSachets(String grams);

  /// No description provided for @formConcentrate.
  ///
  /// In en, this message translates to:
  /// **'syrup only — {dose}ml makes a {makes}ml glass'**
  String formConcentrate(String dose, String makes);

  /// No description provided for @formServing.
  ///
  /// In en, this message translates to:
  /// **'label serving {grams}g'**
  String formServing(String grams);

  /// No description provided for @caveatCook.
  ///
  /// In en, this message translates to:
  /// **'Dry weight, as sold. Oil, butter or vegetables you add while cooking are not on the label, so they are not counted here.'**
  String get caveatCook;

  /// No description provided for @caveatConcentrate.
  ///
  /// In en, this message translates to:
  /// **'Syrup only. We count the syrup you pour, not the water you add.'**
  String get caveatConcentrate;

  /// No description provided for @caveatPiece.
  ///
  /// In en, this message translates to:
  /// **'~{grams}g per biscuit. Counting pieces is closer to the truth than guessing grams.'**
  String caveatPiece(String grams);

  /// No description provided for @todayNutritionLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s intake'**
  String get todayNutritionLabel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name} 👋'**
  String homeGreeting(String name);

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Surat, Gujarat'**
  String get homeLocation;

  /// No description provided for @scanCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get scanCtaTitle;

  /// No description provided for @scanCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Barcode or photo — takes a few seconds'**
  String get scanCtaSubtitle;

  /// No description provided for @scanCtaSemantics.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get scanCtaSemantics;

  /// No description provided for @statScansWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Scans this week'**
  String get statScansWeekLabel;

  /// No description provided for @statFlagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Flags caught'**
  String get statFlagsLabel;

  /// No description provided for @statLanguagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Languages used'**
  String get statLanguagesLabel;

  /// No description provided for @recentScansLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent scans'**
  String get recentScansLabel;

  /// No description provided for @flagsPill.
  ///
  /// In en, this message translates to:
  /// **'{count} flags'**
  String flagsPill(int count);

  /// No description provided for @clearPill.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearPill;

  /// No description provided for @scanUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scanning isn\'t available in this build yet.'**
  String get scanUnavailable;

  /// No description provided for @recentScanUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scan results aren\'t available in this build yet.'**
  String get recentScanUnavailable;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent scans yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products you scan will show up here.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the home screen.'**
  String get homeError;

  /// No description provided for @scanModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to scan?'**
  String get scanModeTitle;

  /// No description provided for @scanModeBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanModeBarcodeTitle;

  /// No description provided for @scanModeBarcodeBody.
  ///
  /// In en, this message translates to:
  /// **'Fastest option — works for any packaged product already in our database.'**
  String get scanModeBarcodeBody;

  /// No description provided for @scanModePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get scanModePhotoTitle;

  /// No description provided for @scanModePhotoBody.
  ///
  /// In en, this message translates to:
  /// **'For products without a barcode, or not yet in our database. Two photos: nutrition panel and ingredients.'**
  String get scanModePhotoBody;

  /// No description provided for @scanModeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Choose how to scan a product'**
  String get scanModeSemantics;

  /// No description provided for @scanBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Align the barcode within the frame'**
  String get scanBarcodeHint;

  /// No description provided for @scanNoBarcode.
  ///
  /// In en, this message translates to:
  /// **'No barcode?'**
  String get scanNoBarcode;

  /// No description provided for @scanSwitchToPhoto.
  ///
  /// In en, this message translates to:
  /// **'Switch to photo mode'**
  String get scanSwitchToPhoto;

  /// No description provided for @scanPhotoHint1.
  ///
  /// In en, this message translates to:
  /// **'Photo 1 of 2 — nutrition panel'**
  String get scanPhotoHint1;

  /// No description provided for @scanPhotoHint2.
  ///
  /// In en, this message translates to:
  /// **'Photo 2 of 2 — ingredients'**
  String get scanPhotoHint2;

  /// No description provided for @scanFlashLabel.
  ///
  /// In en, this message translates to:
  /// **'Toggle flash'**
  String get scanFlashLabel;

  /// No description provided for @scanGalleryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Picking a photo from the gallery isn\'t available in this build yet.'**
  String get scanGalleryUnavailable;

  /// No description provided for @scanCameraUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get scanCameraUnavailableTitle;

  /// No description provided for @scanCameraUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Enable camera access in Settings to scan for real — or keep going with a demo scan for now.'**
  String get scanCameraUnavailableBody;

  /// No description provided for @scanCaptureFallback.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the photo — continuing with a demo scan.'**
  String get scanCaptureFallback;

  /// No description provided for @scanProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading the label…'**
  String get scanProcessingTitle;

  /// No description provided for @scanStepBarcodeMatched.
  ///
  /// In en, this message translates to:
  /// **'Barcode matched to FSSAI database'**
  String get scanStepBarcodeMatched;

  /// No description provided for @scanStepPhotosReceived.
  ///
  /// In en, this message translates to:
  /// **'Label photos received'**
  String get scanStepPhotosReceived;

  /// No description provided for @scanStepNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition panel extracted'**
  String get scanStepNutrition;

  /// No description provided for @scanStepAdditives.
  ///
  /// In en, this message translates to:
  /// **'Checking additives and allergens'**
  String get scanStepAdditives;

  /// No description provided for @scanStepScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring against WHO / ICMR-NIN limits'**
  String get scanStepScoring;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read this label. Please try again.'**
  String get scanError;

  /// No description provided for @scanStatSodiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Sodium per 80 g pack'**
  String get scanStatSodiumLabel;

  /// No description provided for @scanStatConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition flagged'**
  String get scanStatConditionLabel;

  /// No description provided for @scanStatAdditivesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additives'**
  String get scanStatAdditivesLabel;

  /// No description provided for @scanStatAllergensLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get scanStatAllergensLabel;

  /// No description provided for @scanStatScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Label read score'**
  String get scanStatScoreLabel;

  /// No description provided for @scanBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} things flagged on this label'**
  String scanBannerTitle(int count);

  /// No description provided for @scanDepthLabel.
  ///
  /// In en, this message translates to:
  /// **'Decoded in depth'**
  String get scanDepthLabel;

  /// No description provided for @scanLabelFlagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Flags on this label'**
  String get scanLabelFlagsLabel;

  /// No description provided for @scanFullDecode.
  ///
  /// In en, this message translates to:
  /// **'See full label decode'**
  String get scanFullDecode;

  /// No description provided for @fullDecodeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The full label decode isn\'t available in this build yet.'**
  String get fullDecodeUnavailable;

  /// No description provided for @shareUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing isn\'t available in this build yet.'**
  String get shareUnavailable;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products you scan will show up here.'**
  String get historyEmptySubtitle;

  /// No description provided for @historyError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your history.'**
  String get historyError;

  /// No description provided for @demoDataBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoDataBadge;

  /// No description provided for @labelToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String labelToday(String time);

  /// No description provided for @labelYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {time}'**
  String labelYesterday(String time);

  /// No description provided for @labelDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String labelDaysAgo(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your profile.'**
  String get profileError;

  /// No description provided for @profileDemoBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo profile'**
  String get profileDemoBadge;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @languageRowLabel.
  ///
  /// In en, this message translates to:
  /// **'Voice language'**
  String get languageRowLabel;

  /// No description provided for @healthFlagsRowLabel.
  ///
  /// In en, this message translates to:
  /// **'Health flags'**
  String get healthFlagsRowLabel;

  /// No description provided for @onThisDevice.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get onThisDevice;

  /// No description provided for @noFlagsSet.
  ///
  /// In en, this message translates to:
  /// **'None set'**
  String get noFlagsSet;

  /// No description provided for @healthFlagsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Health flags'**
  String get healthFlagsSheetTitle;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'Every figure is read from the printed label. FoodLens does not give medical advice.'**
  String get disclaimerText;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersionLabel;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutTitle;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll return to the sign-in screen. Your language and flags stay on this device.'**
  String get signOutMessage;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingLabel;

  /// No description provided for @a11yLanguageSwitcher.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get a11yLanguageSwitcher;

  /// No description provided for @a11yBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get a11yBack;

  /// No description provided for @a11yOpenLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get a11yOpenLanguage;

  /// No description provided for @a11yEditHealthFlags.
  ///
  /// In en, this message translates to:
  /// **'Edit health flags'**
  String get a11yEditHealthFlags;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
