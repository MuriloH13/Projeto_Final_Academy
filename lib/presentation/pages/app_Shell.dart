import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:projeto_final_academy/presentation/states/transport_State.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_AppBar.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../core/theme/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/language_selector.dart';
import '../states/group_State.dart';
import '../states/participant_State.dart';
import '../utils/bottom_NavBar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MapsController>().getPosition(context);
    });
  }

  int currentIndex = 0;

  final List<Widget> _pages = const [
    TravelPlannerScreen(),
    MyTripScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: AppNavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class TravelPlannerScreen extends StatelessWidget {
  const TravelPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.watch<MapsController>();
    final groupState = Provider.of<GroupState>(context);
    final participantState = Provider.of<ParticipantState>(context);
    final transportState = Provider.of<TransportState>(context);

    groupState.load();
    participantState.load();
    transportState.load();

    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.tripPlannerScreenTitle,
        subtitle:
          'Gaspar'
            // '${AppLocalizations.of(context)!.locationLatitude} ${local.lat} ${AppLocalizations.of(context)!.locationLongitude} ${local.long}',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      // controller: travelController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppLocalizations.of(
                          context,
                        )!.tripPlannerSearchBar,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groupState.groupList.length,
                    itemBuilder: (context, index) {
                      final group = groupState.groupList[index];

                      final participantsInGroup = participantState
                          .participantList
                          .where((p) => p.groupId == group.id)
                          .toList();

                      final transportsInGroup = transportState.transportList
                          .where((t) => t.groupId == group.id)
                          .toList();

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Card(
                          child: ExpansionTile(
                            title: Text(
                              '${AppLocalizations.of(context)!.tripPlannerTripName} ${group.groupName}',
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.tripPlannerParticipants} ${participantsInGroup.length}',
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.participantScreen,
                                        arguments: group.id,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await groupState.delete(group);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              ...participantsInGroup.map((participant) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        participant.photo != null &&
                                            participant.photo!.isNotEmpty
                                        ? FileImage(File(participant.photo!))
                                        : null,
                                    child:
                                        participant.photo == null ||
                                            participant.photo!.isEmpty
                                        ? Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(
                                    '${AppLocalizations.of(context)!.tripPlannerParticipantName} ${participant.name}',
                                  ),
                                  subtitle: Text(
                                    '${AppLocalizations.of(context)!.tripPlannerParticipantAge} ${participant.age}',
                                  ),
                                );
                              }).toList(),
                              if (transportsInGroup.isNotEmpty)
                                ListTile(
                                  title: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.transportScreenTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ...transportsInGroup.map((transport) {
                                return ListTile(
                                  title: Text(
                                    '${AppLocalizations.of(context)!.transportName} ${transport.transportName}',
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.groupScreen);
              },
              child: Text(AppLocalizations.of(context)!.tripPlannerTripButton),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appShellMyTripText),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [Center(child: Card(child: Text('Participantes')))],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLocale = languageProvider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appShellSettingsText),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsDarkModeSwitch),
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: LanguageSelector(),
            ),
            Text('Main Settings Screen'),
          ],
        ),
      ),
    );
  }
}
