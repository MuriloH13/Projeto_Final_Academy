import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/utils/trip_Card.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/trip_State.dart';
import '../utils/dynamic_AppBar.dart';

class TravelPlannerScreen extends StatelessWidget {
  const TravelPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TripState>();

    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.tripPlannerScreenTitle,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.tripList.length,
              itemBuilder: (context, index) {
                final trips = state.tripList[index];
                return TripCard(trip: trips);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.tripScreen);
            },
            child: Text(
              AppLocalizations.of(context)!.tripPlannerTripButton,
            ),
          ),
        ],
      ),
    );
  }
}
