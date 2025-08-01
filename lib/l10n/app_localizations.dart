import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appShellTripPlannerText.
  ///
  /// In en, this message translates to:
  /// **'Trip Planner'**
  String get appShellTripPlannerText;

  /// No description provided for @appShellMyTripText.
  ///
  /// In en, this message translates to:
  /// **'My trip'**
  String get appShellMyTripText;

  /// No description provided for @appShellSettingsText.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appShellSettingsText;

  /// No description provided for @locationDisabledLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable your device localization'**
  String get locationDisabledLocationMessage;

  /// No description provided for @locationNeedAccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to authorize location access'**
  String get locationNeedAccessMessage;

  /// No description provided for @locationLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get locationLatitude;

  /// No description provided for @locationLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get locationLongitude;

  /// No description provided for @tripPlannerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripPlannerScreenTitle;

  /// No description provided for @tripPlannerSearchBar.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tripPlannerSearchBar;

  /// No description provided for @tripPlannerTripName.
  ///
  /// In en, this message translates to:
  /// **'Trip name:'**
  String get tripPlannerTripName;

  /// No description provided for @tripPlannerParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants:'**
  String get tripPlannerParticipants;

  /// No description provided for @tripPlannerParticipantName.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get tripPlannerParticipantName;

  /// No description provided for @tripPlannerParticipantAge.
  ///
  /// In en, this message translates to:
  /// **'Age:'**
  String get tripPlannerParticipantAge;

  /// No description provided for @tripPlannerTripButton.
  ///
  /// In en, this message translates to:
  /// **'New travel plan'**
  String get tripPlannerTripButton;

  /// No description provided for @settingsDarkModeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkModeSwitch;

  /// No description provided for @settingsLanguageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsLanguageSwitch;

  /// No description provided for @groupScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get groupScreenTitle;

  /// No description provided for @groupTripName.
  ///
  /// In en, this message translates to:
  /// **'Trip to the Maldives'**
  String get groupTripName;

  /// No description provided for @transportScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Transports'**
  String get transportScreenTitle;

  /// No description provided for @transportName.
  ///
  /// In en, this message translates to:
  /// **'Transport Name:'**
  String get transportName;

  /// No description provided for @participantsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsScreenTitle;

  /// No description provided for @participantsPerson.
  ///
  /// In en, this message translates to:
  /// **'Pessoa'**
  String get participantsPerson;

  /// No description provided for @participantsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get participantsName;

  /// No description provided for @participantsAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get participantsAge;

  /// No description provided for @durationScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip duration'**
  String get durationScreenTitle;

  /// No description provided for @generalConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get generalConfirmButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
