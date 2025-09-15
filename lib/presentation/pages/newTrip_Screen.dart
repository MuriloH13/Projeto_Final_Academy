import 'package:flutter/material.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_AppBar.dart';

import '../../core/routes/app_Routes.dart';

class NewTripScreen extends StatelessWidget {
  const NewTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.tripPlannerScreenTitle,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.tripStatusNoTrips,
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
