import 'dart:io';

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
import 'package:projeto_final_academy/presentation/utils/translation_Util.dart';
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
  late CompleteTrip completeTrip;
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
  List<File?> _tripImageControllers = [];
  List<File?> _participantImageControllers = [];
  List<TextEditingController> _transportNameControllers = [];
  List<TextEditingController> _experienceTypeControllers = [];
  List<ValueNotifier<DateTime?>> _cityDepartureControllers = [];
  List<ValueNotifier<DateTime?>> _cityArrivalControllers = [];
  ValueNotifier<DateTime?> _controllerTripDepartureDate = ValueNotifier(null);
  ValueNotifier<DateTime?> _controllerTripArrivalDate = ValueNotifier(null);

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
        completeTrip = result;
        groupNameController.text = completeTrip.tripName;

        participantsController.text = completeTrip.participants.length
            .toString();

        _participantNameControllers = completeTrip.participants
            .map((p) => TextEditingController(text: p.name))
            .toList();

        _participantAgeControllers = completeTrip.participants
            .map((p) => TextEditingController(text: p.age.toString()))
            .toList();

        _tripImageControllers = completeTrip.tripImages.map((p) {
          return File(p.photo);
        }).toList();

        _participantImageControllers = completeTrip.participants.map((p) {
          final image = p.photo;
          if (image != null) {
            return File(image);
          }
        }).toList();

        _transportNameControllers = completeTrip.transports
            .map((p) => TextEditingController(text: p.transportName.toString()))
            .toList();

        _experienceTypeControllers = completeTrip.experiences
            .map((p) => TextEditingController(text: p.type.toString()))
            .toList();

        _controllerTripDepartureDate = ValueNotifier(completeTrip.departure);

        _controllerTripArrivalDate = ValueNotifier(completeTrip.arrival);

        _cityDepartureControllers = completeTrip.stops.map((p) {
          final date = p.departure;
          return ValueNotifier<DateTime?>(date);
        }).toList();

        _cityArrivalControllers = completeTrip.stops.map((p) {
          final date = p.arrival;
          return ValueNotifier<DateTime?>(date);
        }).toList();

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
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    List<String> transportOptions = [
      "Car",
      "Motorcycle",
      "Bus",
      "Airplane",
      "Cruise",
    ];

    List<String> experienceOptions = <String>[
      "Immersion in a different culture",
      "Explore alternative cuisine",
      "Historical sites tour",
      "Visit local establishments",
      "Contact with nature",
    ];

    return Scaffold(
      appBar: DynamicAppBar(
        title: AppLocalizations.of(context)!.editTripScreenTitle,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.archive),
                      labelText: AppLocalizations.of(
                        context,
                      )!.tripPlannerTripName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (completeTrip.tripImages.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: completeTrip.tripImages.length,
                        itemBuilder: (context, index) {
                          if (completeTrip.tripImages[index] != null) {
                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: FileImage(
                                _tripImageControllers[index]!,
                              ),
                            );
                          } else {
                            return IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add_circle_outline),
                            );
                          }
                        },
                      ),
                    ),
                  Row(
                    children: [
                      dateFormField(
                        context: context,
                        controller: _controllerTripDepartureDate,
                        locale: languageProvider.locale,
                        label: AppLocalizations.of(context)!.tripDepartureDate,
                      ),
                      dateFormField(
                        context: context,
                        controller: _controllerTripArrivalDate,
                        locale: languageProvider.locale,
                        label: AppLocalizations.of(context)!.tripArrivalDate,
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.participantsScreenTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DynamicParticipantFields(
                    isDetails: true,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: completeTrip.transports.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.transportScreenTitle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButtonFormField<String>(
                              value:
                                  _transportNameControllers[index]
                                      .text
                                      .isNotEmpty
                                  ? _transportNameControllers[index].text
                                  : transportOptions.first,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(
                                  context,
                                )!.transportName,
                                prefixIcon: Icon(Icons.train),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: transportOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    TranslationUtil.translate(context, value),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _transportNameControllers[index].text =
                                      newValue!;
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
                    itemCount: completeTrip.experiences.length,
                    itemBuilder: (context, index) {
                      String currentValue = _experienceTypeControllers[index]
                          .text
                          .trim();
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
                              labelText: AppLocalizations.of(
                                context,
                              )!.experienceName,
                              prefixIcon: Icon(Icons.train),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: experienceOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  TranslationUtil.translate(context, value),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _experienceTypeControllers[index].text =
                                      newValue;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: completeTrip.stops.length,
                    itemBuilder: (context, index) {
                      print(_cityDepartureControllers[index]);
                      final cityName = completeTrip.stops[index].name;
                      return Column(
                        children: [
                          Text(cityName),
                          Row(
                            children: [
                              dateFormField(
                                context: context,
                                controller: _cityDepartureControllers[index],
                                locale: languageProvider.locale,
                                label: AppLocalizations.of(
                                  context,
                                )!.tripDepartureDate,
                              ),
                              dateFormField(
                                context: context,
                                controller: _cityArrivalControllers[index],
                                locale: languageProvider.locale,
                                label: AppLocalizations.of(
                                  context,
                                )!.tripArrivalDate,
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
                      final departureDate = _controllerTripDepartureDate.value;
                      final arrivalDate = _controllerTripArrivalDate.value;
                      final updatedTrip = Trip(
                        id: tripId,
                        groupName: groupNameController.text,
                        status: completeTrip.status,
                        participants: completeTrip.participants.length,
                        departure: departureDate,
                        arrival: arrivalDate,
                        stops: completeTrip.stops.length,
                        experiences: completeTrip.experiences.length,
                      );

                      // List of the participants that are going to be updated
                      List<Participant> updatedParticipants = [];
                      for (
                        int i = 0;
                        i < completeTrip.participants.length;
                        i++
                      ) {
                        final name = _participantNameControllers[i].text;
                        final age =
                            int.tryParse(_participantAgeControllers[i].text) ??
                            0;
                        final photoFile = _participantImageControllers[i];

                        final updatedParticipant = Participant(
                          id: completeTrip.participants[i].id,
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
                      for (int i = 0; i < completeTrip.transports.length; i++) {
                        final updatedTransport = Transport(
                          id: completeTrip.transports[i].id,
                          transportName: _transportNameControllers[i].text,
                          tripId: tripId,
                        );
                        await transportController.update(updatedTransport);
                      }

                      // Update for the ExperienceTable
                      for (
                        int i = 0;
                        i < completeTrip.experiences.length;
                        i++
                      ) {
                        final updatedExperience = Experience(
                          id: completeTrip.experiences[i].id,
                          type: _experienceTypeControllers[i].text,
                          tripId: tripId,
                        );
                        await experienceController.update(updatedExperience);
                      }
                      for (int i = 0; i < completeTrip.stops.length; i++) {
                        final departureDate =
                            _cityDepartureControllers[i].value;
                        final arrivalDate = _cityArrivalControllers[i].value;

                        final updatedStop = Stop(
                          id: completeTrip.stops[i].id,
                          name: completeTrip.stops[i].name,
                          address: completeTrip.stops[i].address,
                          latitude: completeTrip.stops[i].latitude,
                          longitude: completeTrip.stops[i].longitude,
                          departure: departureDate,
                          arrival: arrivalDate,
                          tripId: tripId,
                        );
                        await cityController.update(updatedStop);
                      }
                      Navigator.pop(context, updatedTrip);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.generalConfirmButton,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
