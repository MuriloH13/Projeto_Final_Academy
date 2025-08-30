import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../states/participant_State.dart';
import '../utils/dynamic_ParticipantForm.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final state = Provider.of<ParticipantState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.participantsScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: DynamicParticipantFields(
                      nameControllers: state.nameControllers,
                      ageControllers: state.ageControllers,
                      participantImage: state.imageControllers,
                      participantList: state.participantList,
                      onAdd: state.addParticipant,
                      onRemove: state.removeParticipant,
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
                  AppRoutes.transportScreen,
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
