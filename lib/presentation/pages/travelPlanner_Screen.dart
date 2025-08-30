import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final_academy/domain/entities/trip.dart';
import 'package:projeto_final_academy/presentation/utils/editTrip_Dialog.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../states/experience_State.dart';
import '../states/participant_State.dart';
import '../states/stop_State.dart';
import '../states/transport_State.dart';
import '../states/trip_State.dart';
import '../utils/dynamic_AppBar.dart';
import '../utils/translation_Util.dart';

class TravelPlannerScreen extends StatelessWidget {
  const TravelPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    // Display format for the date on the stops departure/arrival date
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

    // final trips = tripState.tripList;

    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.tripPlannerScreenTitle,
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
                        hintText: AppLocalizations.of(context)!.searchBar,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tripState.tripList.length,
                    itemBuilder: (listViewContext, index) {
                      final trip = tripState.tripList[index];

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
                              'Status: ${trip.status == 0 ? AppLocalizations.of(context)!.tripStatusCompleted : AppLocalizations.of(context)!.tripStatusOngoing}\n'
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
                                ...experiencesInGroup.map((experience) {
                                  return ListTile(
                                    title: Text(
                                      '${AppLocalizations.of(context)!.experienceName} '
                                      '${TranslationUtil.translate(context, experience.type)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.tripScreen);
              },
              child: Text(AppLocalizations.of(context)!.tripPlannerTripButton),
            ),
          ),
        ],
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
