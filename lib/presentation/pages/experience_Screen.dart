import 'package:flutter/material.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_Routes.dart';
import '../states/experience_State.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  late String dropDownValue;

  @override
  void initState() {
      super.initState();
      dropDownValue = "";
  }
  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final state = Provider.of<ExperienceState>(context);

    List<String> experienceList = <String>[
      AppLocalizations.of(context)!.experienceCulturalImmersion,
      AppLocalizations.of(context)!.experienceAlternativeCuisine,
      AppLocalizations.of(context)!.experienceHistoricalSites,
      AppLocalizations.of(context)!.experienceLocalEstablishments,
      AppLocalizations.of(context)!.experienceContactWithNature,
    ];

    if(dropDownValue.isEmpty) {
      dropDownValue = state.selectedExperience.isNotEmpty
          ? state.selectedExperience
          : experienceList.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.experienceScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  DropdownButton<String>(
                  value: experienceList.contains(dropDownValue) ? dropDownValue : experienceList.first,
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (String? value) {
                  state.selectedExperience = value!;
                  },
                  items:
                  experienceList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value),
                  );
                  }).toList(),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await state.insert(groupId);
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.cityScreen,
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
