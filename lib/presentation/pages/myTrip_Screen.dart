import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final_academy/presentation/utils/editTrip_Dialog.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../domain/entities/trip.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../states/experience_State.dart';
import '../states/participant_State.dart';
import '../states/stop_State.dart';
import '../states/transport_State.dart';
import '../states/trip_State.dart';
import '../utils/translation_Util.dart';

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final displayFormat = (() {
      switch (languageProvider.locale.languageCode) {
        case 'en':
          return DateFormat('MM/dd/yyyy');
        case 'es':
        case 'pt':
        default:
          return DateFormat('dd/MM/yyyy');
      }
    })();

    final tripState = Provider.of<TripState>(context);
    final participantState = Provider.of<ParticipantState>(context);
    final transportState = Provider.of<TransportState>(context);
    final experienceState = Provider.of<ExperienceState>(context);
    final stopState = Provider.of<StopState>(context);

    final ongoingTrips = tripState.tripList
        .where((trip) => trip.status == 1)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appShellMyTripText),
      ),
      body: ongoingTrips.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.tripStatusNoOngoingTrips,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppLocalizations.of(context)!.searchBar,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ongoingTrips.length,
                    itemBuilder: (context, index) {
                      final trip = ongoingTrips[index];

                      final participantsInGroup = participantState
                          .participantList
                          .where((p) => p.tripId == trip.id)
                          .toList();

                      final transportsInGroup = transportState.transportList
                          .where((t) => t.tripId == trip.id)
                          .toList();

                      final experiencesInGroup = experienceState.experienceList
                          .where((t) => t.tripId == trip.id)
                          .toList();

                      final citiesInGroup = stopState.citiesList
                          .where((t) => t.tripId == trip.id)
                          .toList();

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Card(
                          child: ExpansionTile(
                            title: Text(
                              '${AppLocalizations.of(context)!.tripPlannerTripName} ${trip.groupName}',
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.tripDepartureDate}: ${trip.departure != null ? displayFormat.format(trip.departure!) : '-'}\n'
                              '${AppLocalizations.of(context)!.tripArrivalDate}: ${trip.arrival != null ? displayFormat.format(trip.arrival!) : '-'}\n'
                              'Status: ${AppLocalizations.of(context)!.tripStatusOngoing}\n'
                              '${AppLocalizations.of(context)!.tripPlannerParticipants} ${participantsInGroup.length}',
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _onEditPressed(context, trip),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await tripState.delete(trip);
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
                                    '${AppLocalizations.of(context)!.transportName} '
                                    '${TranslationUtil.translate(context, transportsInGroup.first.transportName)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (experiencesInGroup.isNotEmpty)
                                ListTile(
                                  title: Text(
                                    '${AppLocalizations.of(context)!.experienceName} '
                                    '${TranslationUtil.translate(context, experiencesInGroup.first.type)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (citiesInGroup.isNotEmpty)
                                ListTile(
                                  title: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.stopScreenTitle,
                                  ),
                                ),
                              ...citiesInGroup.map((city) {
                                return ListTile(
                                  title: Text(
                                    '${AppLocalizations.of(context)!.stopName} ${city.name}',
                                  ),
                                  subtitle: Text(
                                    '${AppLocalizations.of(context)!.tripDepartureDate}: ${city.departure != null ? displayFormat.format(city.departure!) : '-'}\n'
                                    '${AppLocalizations.of(context)!.tripArrivalDate}: ${city.arrival != null ? displayFormat.format(city.arrival!) : '-'}',
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
    );
  }

  Future<void> _onEditPressed(BuildContext context, Trip trip) async {
    final shouldNavigate = await showDialog<bool>(
      context: context,
      builder: (context) {
        return EditTripDialog(tripId: trip.id!);
      },
    );
    if (shouldNavigate != true) {
      return;
    }

    if (context.mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.editTripScreen,
        arguments: trip.id!,
      );
    }
  }
}


