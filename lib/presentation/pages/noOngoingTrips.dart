import 'package:flutter/material.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_AppBar.dart';

import '../../core/routes/app_Routes.dart';

class NoOngoingtrips extends StatelessWidget {
  const NoOngoingtrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.appShellMyTripText,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.tripStatusNoOngoingTrips,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.tripScreen);
            },
            child: Text(AppLocalizations.of(context)!.tripPlannerTripButton),
          ),
        ],
      ),
    );
  }
}
