
import 'package:flutter/cupertino.dart';
import 'package:projeto_final_academy/presentation/pages/stop_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/editTrip_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/transport_Screen.dart';

import '../../presentation/pages/app_Shell.dart';
import '../../presentation/pages/duration_Screen.dart';
import '../../presentation/pages/experience_Screen.dart';
import '../../presentation/pages/trip_Screen.dart';
import '../../presentation/pages/participant_Screen.dart';

class AppRoutes {
  static const String homeScreen = '/home';
  static const String editTripScreen = '/editTripScreen';
  static const String tripScreen = '/trip';
  static const String participantScreen = '/participants';
  static const String transportScreen = '/transport';
  static const String experienceScreen = '/experience';
  static const String cityScreen = '/city';
  static const String durationScreen = '/duration';

  static Map<String, WidgetBuilder> get routes => {
    homeScreen: (_) => const AppShell(),
    editTripScreen: (_) => const EditTripScreen(),
    tripScreen: (_) => const TripScreen(),
    participantScreen: (_) => const ParticipantScreen(),
    transportScreen: (_) => const TransportScreen(),
    experienceScreen: (_) => const ExperienceScreen(),
    cityScreen: (_) => const CityScreen(),
    durationScreen: (_) => const DurationScreen(),
  };
}