import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../states/trip_State.dart';
import '../utils/date_FormField.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TripState>(context);
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tripScreenTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  controller: state.controllerGroupName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: AppLocalizations.of(context)!.tripName,
                    prefixIcon: Icon(Icons.archive),
                  ),
                ),
                Row(
                  children: [
                    dateFormField(
                      context: context,
                      controller: state.controllerTripDepartureDate,
                      locale: languageProvider.locale,
                      label: AppLocalizations.of(context)!.tripDepartureDate,
                    ),
                    dateFormField(
                      context: context,
                      controller: state.controllerTripArrivalDate,
                      locale: languageProvider.locale,
                      label: AppLocalizations.of(context)!.tripArrivalDate,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final participantState = Provider.of<ParticipantState>(context, listen: false);

                final arrivalDate = state.controllerTripArrivalDate.value;
                if (arrivalDate == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Data inválida')));
                  return;
                }

                final now = DateTime.now();
                final int isFuture = arrivalDate.isAfter(now) ? 1 : 0;
                state.groupStatus = isFuture;
                final groupId = await state.insert();

                participantState.addParticipant();

                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.participantScreen,
                  arguments: groupId,
                );
              },
              child: Text(AppLocalizations.of(context)!.generalConfirmButton),
            ),
          ),
        ],
      ),
    );
  }
}
