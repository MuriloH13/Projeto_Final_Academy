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
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    final int groupId = ModalRoute.of(context)!.settings.arguments as int;
    final state = Provider.of<ExperienceState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.experienceScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.selectedExperiences.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: DynamicDropdownButton(
                      items: state.experienceOptions,
                      value: state.selectedExperiences[index],
                      onChanged: (value) {
                        if (value != null) {
                          state.updateExperience(index, value);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    state.addExperience();
                  },
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
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
