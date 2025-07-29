
import 'package:flutter/cupertino.dart';
import 'package:projeto_final_academy/presentation/pages/transport_Screen.dart';

import '../../presentation/pages/app_Shell.dart';
import '../../presentation/pages/duration_Screen.dart';
import '../../presentation/pages/group_Screen.dart';
import '../../presentation/pages/participant_Screen.dart';

class AppRoutes {
  static const String homeScreen = '/home';
  static const String groupScreen = '/group';
  static const String transportScreen = '/transport';
  static const String participantScreen = '/participants';
  static const String durationScreen = '/duration';

  static Map<String, WidgetBuilder> get routes => {
    homeScreen: (_) => const AppShell(),
    groupScreen: (_) => const GroupScreen(),
    transportScreen: (_) => const TransportScreen(),
    participantScreen: (_) => const ParticipantScreen(),
    durationScreen: (_) => const DurationScreen(),
  };
}