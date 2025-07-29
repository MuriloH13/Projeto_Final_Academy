// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appShellTripPlannerText => 'Trip Planner';

  @override
  String get appShellMyTripText => 'My trip';

  @override
  String get appShellSettingsText => 'Settings';

  @override
  String get locationDisabledLocationMessage => 'Please enable your device localization';

  @override
  String get locationNeedAccessMessage => 'You need to authorize location access';

  @override
  String get locationLatitude => 'Latitude';

  @override
  String get locationLongitude => 'Longitude';

  @override
  String get tripPlannerScreenTitle => 'Trips';

  @override
  String get tripPlannerSearchBar => 'Search';

  @override
  String get tripPlannerTripName => 'Trip name:';

  @override
  String get tripPlannerParticipants => 'Participants:';

  @override
  String get tripPlannerParticipantName => 'Name:';

  @override
  String get tripPlannerParticipantAge => 'Age:';

  @override
  String get tripPlannerTripButton => 'New travel plan';

  @override
  String get settingsDarkModeSwitch => 'Dark Mode';

  @override
  String get settingsLanguageSwitch => 'Languages';

  @override
  String get groupScreenTitle => 'Trip';

  @override
  String get groupTripName => 'Trip to the Maldives';

  @override
  String get transportScreenTitle => 'Transports';

  @override
  String get transportName => 'Transport Name:';

  @override
  String get participantsScreenTitle => 'Participants';

  @override
  String get participantsPerson => 'Pessoa';

  @override
  String get participantsName => 'Name';

  @override
  String get participantsAge => 'Age';

  @override
  String get durationScreenTitle => 'Trip duration';

  @override
  String get generalConfirmButton => 'Confirm';
}
