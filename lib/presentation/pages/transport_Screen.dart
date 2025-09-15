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
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;

    return ChangeNotifierProvider(
      create: (_) => TransportState(),
      child: Consumer<TransportState>(
        builder: (context, state, child) {
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
                            items: state.transportOptions,
                            value: state.selectedTransport,
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
                    child: Text(
                      AppLocalizations.of(context)!.generalConfirmButton,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
