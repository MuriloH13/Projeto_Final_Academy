import 'package:flutter/material.dart';
import '../../core/routes/app_Routes.dart';
import '../../domain/entities/trip.dart';
import '../../l10n/app_localizations.dart';
import '../utils/dynamic_AppBar.dart';
import '../utils/trip_Card.dart';

class MyTripScreen extends StatelessWidget {
  final List<Trip> trips;
  const MyTripScreen({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    final activeTrips = TripCard.getActiveTrips(trips);

    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.appShellMyTripText,
      ),
      body: Column(
        children: [
          Expanded(
            child: trips.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.tripStatusNoOngoingTrips,
                    ),
                  )
                : ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return TripCard(trip: trip);
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
