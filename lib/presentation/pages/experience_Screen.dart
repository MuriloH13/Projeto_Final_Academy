import 'package:flutter/material.dart';
import 'package:projeto_final_academy/l10n/app_localizations.dart';
import 'package:projeto_final_academy/presentation/utils/dropdown_Menu.dart';
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

    //Make so it gets exactly the name passed in AppLocalization without spaces or characters
    List<String> experienceList = <String>[
      "Immersion in a different culture",
      "Explore alternative cuisine",
      "Historical sites tour",
      "Visit local establishments",
      "Contact with nature",
    ];

    //Pass the list to a set making sure that it only exists one of each value
    experienceList.toSet().toList();

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
                  Container(
                    width: double.infinity,
                    child: DynamicDropdownButton(
                        items: experienceList,
                        value: experienceList.contains(dropDownValue) ? dropDownValue : experienceList.first,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              dropDownValue = value;
                              state.selectedExperience = value;
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
