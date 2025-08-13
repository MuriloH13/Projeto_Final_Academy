
import 'package:flutter/cupertino.dart';
import 'package:projeto_final_academy/presentation/pages/city_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/editGroup_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/transport_Screen.dart';
import 'package:projeto_final_academy/presentation/utils/editGroup_Message.dart';

import '../../presentation/pages/app_Shell.dart';
import '../../presentation/pages/duration_Screen.dart';
import '../../presentation/pages/experience_Screen.dart';
import '../../presentation/pages/group_Screen.dart';
import '../../presentation/pages/participant_Screen.dart';

class AppRoutes {
  static const String homeScreen = '/home';
  static const String editDialog = '/editMessage';
  static const String editgroupScreen = '/editGroupScreen';
  static const String groupScreen = '/group';
  static const String participantScreen = '/participants';
  static const String transportScreen = '/transport';
  static const String experienceScreen = '/experience';
  static const String cityScreen = '/city';
  static const String durationScreen = '/duration';

  static Map<String, WidgetBuilder> get routes => {
    homeScreen: (_) => const AppShell(),
    editDialog: (_) => const EditgroupMessage(),
    editgroupScreen: (_) => const EditgroupScreen(),
    groupScreen: (_) => const GroupScreen(),
    participantScreen: (_) => const ParticipantScreen(),
    transportScreen: (_) => const TransportScreen(),
    experienceScreen: (_) => const ExperienceScreen(),
    cityScreen: (_) => const CityScreen(),
    durationScreen: (_) => const DurationScreen(),
  };
}