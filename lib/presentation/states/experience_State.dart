import 'package:flutter/material.dart';
import 'package:projeto_final_academy/core/data/tables/experience_Table.dart';

import '../../domain/entities/experience.dart';

class ExperienceState extends ChangeNotifier {
  ExperienceState() {
    // load();
  }

  String selectedExperience = "";

  final controllerDatabase = ExperienceController();

  final _experienceList = <Experience>[];

  List<Experience> get experienceList => _experienceList;

  Future<void> insert(int groupId) async {
    // Remove any existing transport for this group
    final existingTransports = experienceList.where((t) => t.groupId == groupId).toList();
    for (final t in existingTransports) {
      await controllerDatabase.delete(t);
    }

    // Insert the new transport
    final experience = Experience(
      type: selectedExperience,
      groupId: groupId,
    );
    await controllerDatabase.insert(experience);

    await load();
    notifyListeners();
  }

  Future<void> delete(Experience experience) async {

    await controllerDatabase.delete(experience);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _experienceList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

}