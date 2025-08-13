import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/transport_State.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    dropDownValue = "";
  }

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final state = Provider.of<TransportState>(context);

    List<String> transportList = <String>[
      AppLocalizations.of(context)!.transportCar,
      AppLocalizations.of(context)!.transportMotorcycle,
      AppLocalizations.of(context)!.transportBus,
      AppLocalizations.of(context)!.transportAirPlane,
      AppLocalizations.of(context)!.transportCruise,
    ];

    if (dropDownValue.isEmpty) {
      dropDownValue = state.selectedTransport.isNotEmpty
          ? state.selectedTransport
          : transportList.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transportScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(AppLocalizations.of(context)!.transportName),
                      DropdownButton<String>(
                        value: state.selectedTransport.isNotEmpty
                          ? state.selectedTransport
                        : transportList.first,
                          icon: Icon(Icons.arrow_downward),
                          onChanged: (String? value) {
                            state.selectedTransport = value!;
                          },
                        items:
                        transportList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value),
                          );
                      }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await state.insert(groupId);
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.experienceScreen,
                  arguments: groupId,
                );
              },
              child: Text(AppLocalizations.of(context)!.generalConfirmButton),
            ),
          ],
        ),
      ),
    );
  }
}
