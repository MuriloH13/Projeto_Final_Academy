import 'package:flutter/material.dart';
import 'package:projeto_final_academy/core/data/tables/city_Table.dart';
import 'package:projeto_final_academy/core/data/tables/participant_Table.dart';
import 'package:projeto_final_academy/core/data/tables/transport_Table.dart';
import 'package:projeto_final_academy/domain/entities/completeGroup.dart';
import 'package:projeto_final_academy/domain/entities/participant.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_AppBar.dart';

import '../../core/data/tables/group_Table.dart';
import '../../domain/entities/group.dart';
import '../../l10n/app_localizations.dart';

class EditgroupScreen extends StatefulWidget {
  const EditgroupScreen({super.key});

  @override
  State<EditgroupScreen> createState() => _EditgroupScreenState();
}

class _EditgroupScreenState extends State<EditgroupScreen> {
  late CompleteGroup group;
  late int groupId;
  bool isLoading = true;
  bool hasLoaded = false;

  final GroupController groupController = GroupController();
  final ParticipantController participantController = ParticipantController();
  final TransportController transportController = TransportController();
  final CityController cityController = CityController();

  final groupNameController = TextEditingController();
  final participantsController = TextEditingController();
  final citiesController = TextEditingController();
  final transportsController = TextEditingController();
  // final experiencesController = TextEditingController();

  List<TextEditingController> _participantNameControllers = [];
  List<TextEditingController> _participantAgeControllers = [];
  List<TextEditingController> _transportNameControllers = [];
  List<TextEditingController> _cityControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasLoaded) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is int) {
        groupId = args;
        _loadGroup(); // <- agora pode carregar aqui
        hasLoaded = true;
      }
    }
  }

  Future<void> _loadGroup() async {
    final result = await groupController.getCompleteGroup(groupId);

    if (result != null) {
      setState(() {
        group = result;
        groupNameController.text = group.groupName;
        participantsController.text = group.participants.length.toString();
        transportsController.text = group.transports.length.toString();
        citiesController.text = group.cities.length.toString();
        // experiencesController.text = group.experiences?.length.toString() ?? '0';

        _participantNameControllers = group.participants
            .map((p) => TextEditingController(text: p.name))
            .toList();

        _participantAgeControllers = group.participants
            .map((p) => TextEditingController(text: p.age.toString()))
            .toList();

        _transportNameControllers = group.transports
            .map((p) => TextEditingController(text: p.transportName.toString()))
            .toList();

        _cityControllers = group.cities
            .map((p) => TextEditingController(text: p.name.toString()))
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
    transportsController.dispose();
    // experiencesController.dispose();
    _participantNameControllers.forEach((c) => c.dispose());
    _participantAgeControllers.forEach((c) => c.dispose());
    _transportNameControllers.forEach((c) => c.dispose());
    _cityControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<String> transportOptions = [
      AppLocalizations.of(context)!.transportCar,
      AppLocalizations.of(context)!.transportMotorcycle,
      AppLocalizations.of(context)!.transportBus,
      AppLocalizations.of(context)!.transportAirPlane,
      AppLocalizations.of(context)!.transportCruise,
    ];

    return Scaffold(
      appBar: DynamicAppBar(title: 'Editar Grupo'),
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
                      labelText: 'Nome do Grupo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),
                  ),
                  Text(
                    'Participantes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: group.participants.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextFormField(
                                    controller:
                                        _participantNameControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Nome do participante',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextFormField(
                                    controller:
                                        _participantAgeControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Idade',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ],
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
                                  labelText: 'Transporte Preferido',
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
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Data de chegada',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Data de saída',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  // TextFormField(
                  //   controller: experiencesController,
                  //   keyboardType: TextInputType.number,
                  //   decoration: const InputDecoration(labelText: 'Experiências'),
                  // ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedGroup = Group(
                        id: groupId,
                        groupName: groupNameController.text,
                        participants: group.participants.length,
                        cities: group.cities.length,
                        // experiences: int.tryParse(experiencesController.text),
                      );
                      //List of the participants that are going to be updated
                      List<Participant> updatedParticipants = [];
                      for (int i = 0; i < group.participants.length; i++) {
                        final name = _participantNameControllers[i].text;
                        final age =
                            int.tryParse(_participantAgeControllers[i].text) ??
                            0;

                        final updatedParticipant = Participant(
                          id: group.participants[i].id,
                          name: name,
                          age: age,
                          groupId: groupId,
                        );

                        updatedParticipants.add(updatedParticipant);
                      }
                      //Update of the GroupTable
                      await groupController.update(updatedGroup);
                      //Update for the ParticipantTable
                      for (final participant in updatedParticipants) {
                        await participantController.update(participant);
                      }
                      for (int i = 0; i < group.transports.length; i++) {
                        final updatedTransport = Transport(
                          id: group.transports[i].id,
                          transportName: _transportNameControllers[i].text,
                          groupId: groupId,
                        );
                        await transportController.update(updatedTransport);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
    );
  }
}
