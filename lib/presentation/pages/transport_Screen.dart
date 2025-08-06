import 'package:flutter/material.dart';
import 'package:projeto_final_academy/presentation/utils/dynamic_TransportForm.dart';
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
  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final state = Provider.of<TransportState>(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.transportScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: DynamicTransportFields(
                      transportControllers: state.transportControllers,
                      onAdd: state.addTransport,
                      onRemove: state.removeTransport,
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
                  AppRoutes.participantScreen,
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
