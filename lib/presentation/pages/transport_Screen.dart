import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_Routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/transport_State.dart';
import '../utils/dropdown_Menu.dart';

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
      // Make so it gets exactly the name passed in AppLocalization without spaces or characters
      "Car",
      "Bus",
      "Motorcycle",
      "Cruise",
      "Airplane",
    ];

    // Pass the list to a set making sure that it only exists one of each value
    transportList.toSet().toList();

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
                  Text(AppLocalizations.of(context)!.transportName),
                  Container(
                    width: double.infinity,
                    child: DynamicDropdownButton(
                      items: transportList,
                      value: transportList.contains(dropDownValue) ? dropDownValue : transportList.first,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            dropDownValue = value;
                            state.selectedTransport = value;
                          });
                        }
                      },
                    ),
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
