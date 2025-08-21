import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/trip_State.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TripState>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.groupScreenTitle)),
      body: Column(
        children: [
          Expanded(
            child: TextFormField(
              controller: state.controllerGroupName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: AppLocalizations.of(context)!.groupTripName,
                prefixIcon: Icon(Icons.archive),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final groupId = await state.insert();

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.participantScreen,
                arguments: groupId,
              );
            },
            child: Text(AppLocalizations.of(context)!.generalConfirmButton),
          ),
        ],
      ),
    );
  }
}
