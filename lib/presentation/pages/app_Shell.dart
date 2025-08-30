import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/controllers/geolocator_Controller.dart';
import 'package:projeto_final_academy/presentation/pages/settings_Screen.dart';
import 'package:projeto_final_academy/presentation/pages/travelPlanner_Screen.dart';
import 'package:provider/provider.dart';
import '../utils/bottom_NavBar.dart';
import 'myTrip_Screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
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