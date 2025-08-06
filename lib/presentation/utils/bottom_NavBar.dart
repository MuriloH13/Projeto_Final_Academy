import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      destinations: [
        NavigationDestination(
          selectedIcon: Icon(Icons.commute),
          icon: Icon(Icons.commute_outlined),
          label: AppLocalizations.of(context)!.appShellTripPlannerText,
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.edit_outlined),
          icon: Icon(Icons.edit),
          label: AppLocalizations.of(context)!.appShellMyTripText,
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings_outlined),
          icon: Icon(Icons.settings),
          label: AppLocalizations.of(context)!.appShellSettingsText,
        ),
      ],
    );
  }
}
