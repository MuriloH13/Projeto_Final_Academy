import 'package:flutter/material.dart';
import 'package:projeto_final_academy/core/data/tables/stop_Table.dart';
import 'package:projeto_final_academy/core/data/tables/experience_Table.dart';
import 'package:projeto_final_academy/core/data/tables/participant_Table.dart';
import 'package:projeto_final_academy/core/data/tables/transport_Table.dart';
import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/domain/entities/completeTrip.dart';
import 'package:projeto_final_academy/domain/entities/experience.dart';
import 'package:projeto_final_academy/domain/entities/participant.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';
import 'package:projeto_final_academy/presentation/states/participant_State.dart';
import 'package:projeto_final_academy/presentation/utils/date_FormField.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_AppBar.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_ParticipantForm.dart';
import 'package:provider/provider.dart';

import '../../core/data/tables/trip_Table.dart';
import '../../domain/entities/trip.dart';
import '../../l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class EditTripScreen extends StatefulWidget {
  const EditTripScreen({super.key});

  @override
  State<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  late CompleteTrip group;
  late int tripId;
  bool isLoading = true;
  bool hasLoaded = false;

  final TripController tripController = TripController();
  final ParticipantController participantController = ParticipantController();
  final TransportController transportController = TransportController();
  final ExperienceController experienceController = ExperienceController();
  final StopController cityController = StopController();

  final groupNameController = TextEditingController();
  final participantsController = TextEditingController();
  final citiesController = TextEditingController();
  final cityDeparture = TextEditingController();
  final cityArrival = TextEditingController();

  List<TextEditingController> _participantNameControllers = [];
  List<TextEditingController> _participantAgeControllers = [];
  List<TextEditingController> _transportNameControllers = [];
  List<TextEditingController> _experienceTypeControllers = [];
  List<TextEditingController> _cityDepartureControllers = [];
  List<TextEditingController> _cityArrivalControllers = [];
  List<ValueNotifier<DateTime?>> controllerStopDepartureDate = [];
  List<ValueNotifier<DateTime?>> controllerStopArrivalDate = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasLoaded) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is int) {
        tripId = args;
        _loadGroup();
        hasLoaded = true;
      }
    }
  }

  Future<void> _loadGroup() async {
    final result = await tripController.getCompleteTrip(tripId);

    if (result != null) {

      setState(() {
        group = result;
        groupNameController.text = group.tripName;

        participantsController.text = group.participants.length.toString();

        _participantNameControllers = group.participants
            .map((p) => TextEditingController(text: p.name))
            .toList();

        _participantAgeControllers = group.participants
            .map((p) => TextEditingController(text: p.age.toString()))
            .toList();

        _transportNameControllers = group.transports
            .map((p) => TextEditingController(text: p.transportName.toString()))
            .toList();

        _experienceTypeControllers = group.experiences
            .map((p) => TextEditingController(text: p.type.toString()))
            .toList();

        _cityDepartureControllers = group.cities
            .map((p) {
          final date = p.departure.toString();
          return TextEditingController(
            text: tryParseDate(date).toString(),
          );
        })
            .toList();

        _cityArrivalControllers = group.cities
            .map((p) {
          final date = p.arrival.toString();
          return TextEditingController(
            text: tryParseDate(date).toString(),
          );
        })
            .toList();


        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    groupNameController.dispose();
    participantsController.dispose();
    citiesController.dispose();
    _participantNameControllers.forEach((c) => c.dispose());
    _participantAgeControllers.forEach((c) => c.dispose());
    _transportNameControllers.forEach((c) => c.dispose());
    _experienceTypeControllers.forEach((c) => c.dispose());
    _cityDepartureControllers.forEach((c) => c.dispose());
    _cityArrivalControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final participantState = Provider.of<ParticipantState>(context, listen: false);

    List<String> transportOptions = [
      AppLocalizations.of(context)!.transportCar.trim(),
      AppLocalizations.of(context)!.transportMotorcycle.trim(),
      AppLocalizations.of(context)!.transportBus.trim(),
      AppLocalizations.of(context)!.transportAirPlane.trim(),
      AppLocalizations.of(context)!.transportCruise.trim(),
    ];

    List<String> experienceOptions = <String>[
      AppLocalizations.of(context)!.experienceCulturalImmersion.trim(),
      AppLocalizations.of(context)!.experienceAlternativeCuisine.trim(),
      AppLocalizations.of(context)!.experienceHistoricalSites.trim(),
      AppLocalizations.of(context)!.experienceLocalEstablishments.trim(),
      AppLocalizations.of(context)!.experienceContactWithNature.trim(),
    ];

    experienceOptions = experienceOptions.map((e) => e.trim()).toSet().toList();

    return Scaffold(
      appBar: DynamicAppBar(title: AppLocalizations.of(context)!.editTripScreenTitle),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.archive),
                      labelText: AppLocalizations.of(context)!.tripPlannerTripName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffix: Text(group.status.toString())
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.participantsScreenTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: group.participants.length,
                    itemBuilder: (context, index) {
                          return DynamicParticipantFields(
                              nameControllers: _participantNameControllers,
                              ageControllers: _participantAgeControllers,
                          );
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: group.transports.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DropdownButtonFormField<String>(
                                value: _transportNameControllers[index].text.isNotEmpty
                                    ? _transportNameControllers[index].text
                                    : transportOptions.first,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.transportName,
                                  prefixIcon: Icon(Icons.train),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: transportOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _transportNameControllers[index].text = newValue!;
                                  });
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  Center(
                    child: Text(AppLocalizations.of(context)!.experienceName),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: group.experiences.length,
                    itemBuilder: (context, index) {
                      String currentValue = _experienceTypeControllers[index].text.trim();
                      if (!experienceOptions.contains(currentValue)) {
                        currentValue = experienceOptions.first;
                      }
                      return Padding(
                        padding: EdgeInsets.all(4),
                        child: Container(
                          width: double.infinity,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: currentValue,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.experienceName,
                              prefixIcon: Icon(Icons.train),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: experienceOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _experienceTypeControllers[index].text = newValue;
                                });
                              }
                            },
                          ),
                        )
                      );
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: group.cities.length,
                    itemBuilder: (context, index) {
                      final cityName = group.cities[index].name;
                      return Column(
                        children: [
                          Text(cityName),
                          Row(
                            children: [
                              dateFormField(
                                  context: context,
                                  controller: controllerStopDepartureDate[index],
                                  locale: languageProvider.locale,
                                  label: AppLocalizations.of(context)!.tripDepartureDate
                              ),
                              dateFormField(
                                  context: context,
                                  controller: controllerStopArrivalDate[index],
                                  locale: languageProvider.locale,
                                  label: AppLocalizations.of(context)!.tripArrivalDate
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedTrip = Trip(
                        id: tripId,
                        groupName: groupNameController.text,
                        status: group.status,
                        participants: group.participants.length,
                        cities: group.cities.length,
                        experiences: group.experiences.length,
                      );

                      // List of the participants that are going to be updated
                      List<Participant> updatedParticipants = [];
                      for (int i = 0; i < group.participants.length; i++) {
                        final name = _participantNameControllers[i].text;
                        final age = int.tryParse(_participantAgeControllers[i].text) ?? 0;
                        final photoFile = participantState.participantImage[i];

                        final updatedParticipant = Participant(
                          id: group.participants[i].id,
                          name: name,
                          age: age,
                          photo: photoFile?.path,
                          tripId: tripId,
                        );

                        updatedParticipants.add(updatedParticipant);
                      }
                      // Update of the TripTable
                      await tripController.update(updatedTrip);

                      // Update for the ParticipantTable
                      for (final participant in updatedParticipants) {
                        await participantController.update(participant);
                      }

                      // Update for the TransportTable
                      for (int i = 0; i < group.transports.length; i++) {
                        final updatedTransport = Transport(
                          id: group.transports[i].id,
                          transportName: _transportNameControllers[i].text,
                          tripId: tripId,
                        );
                        await transportController.update(updatedTransport);
                      }

                      // Update for the ExperienceTable
                      for (int i = 0; i < group.experiences.length; i++) {
                        final updatedExperience = Experience(
                          id: group.experiences[i].id,
                          type: _experienceTypeControllers[i].text,
                          tripId: tripId,
                        );
                        await experienceController.update(updatedExperience);
                      }
                      for (int i = 0; i < group.cities.length; i++) {
                        final departureInput = _cityDepartureControllers[i].text;
                        final arrivalInput = _cityArrivalControllers[i].text;

                        final departureDate = tryParseDate(departureInput);
                        final arrivalDate = tryParseDate(arrivalInput);

                        final updatedStop = Stop(
                          id: group.cities[i].id,
                          name: group.cities[i].name,
                          address: group.cities[i].address,
                          latitude: group.cities[i].latitude,
                          longitude: group.cities[i].longitude,
                          departure: departureDate,
                          arrival: arrivalDate,
                          tripId: tripId,
                        );
                        await cityController.update(updatedStop);
                      }
                      Navigator.pop(context, updatedTrip);
                    },
                    child: Text(AppLocalizations.of(context)!.generalConfirmButton),
                  ),
                ],
              ),
            ),
    );
  }
}