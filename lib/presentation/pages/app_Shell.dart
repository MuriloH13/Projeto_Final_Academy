import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/pages/noOngoingTrips.dart';
import 'package:projeto_final_academy/presentation/pages/settings_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/tripPlanner_Screen.dart';
import 'package:projeto_final_academy/presentation/states/experience_State.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:projeto_final_academy/presentation/states/stop_State.dart';
import 'package:projeto_final_academy/presentation/states/transport_State.dart';
import 'package:projeto_final_academy/presentation/states/trip_State.dart';
import 'package:provider/provider.dart';
import '../utils/bottom_NavBar.dart';
import 'myTrip_Screen.dart';
import 'newTrip_Screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripState()),
        ChangeNotifierProvider(create: (_) => ParticipantState()),
        ChangeNotifierProvider(create: (_) => TransportState()),
        ChangeNotifierProvider(create: (_) => StopState()),
        ChangeNotifierProvider(create: (_) => ExperienceState()),
      ],
      builder: (context, child) {
        final tripState = context.watch<TripState>();

        final bool isEmpty = tripState.tripList.isEmpty;


        final ongoingTrips = tripState.tripList
            .where((trip) => trip.status == 1)
            .toList();

        final List<Widget> pages = [
          isEmpty ? const NewtripScreen() : const TravelPlannerScreen(),
          ongoingTrips.isEmpty ? const NoOngoingtrips() :  MyTripScreen(trips: ongoingTrips),
          const SettingsScreen(),
        ];

        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: AppNavBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}