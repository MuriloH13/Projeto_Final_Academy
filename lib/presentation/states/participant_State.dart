import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../core/data/database/app_database.dart';
import '../../core/data/tables/participant_Table.dart';
import '../../domain/entities/participant.dart';

class ParticipantState extends ChangeNotifier {
  ParticipantState() {
    addParticipant();
    load();
  }

  final List<TextEditingController> nameControllers = [];
  final List<TextEditingController> ageControllers = [];
  final List<File?> participantImage = [];
  final controllerDatabase = ParticipantController();
  final _participantList = <Participant>[];

  List<Participant> get participantList => _participantList;

  void addParticipant() {
    nameControllers.add(TextEditingController());
    ageControllers.add(TextEditingController());
    participantImage.add(null);
    notifyListeners();
  }

  Future<void> insert(int groupId) async {
    for (int i = 0; i < nameControllers.length; i++) {
      final participant = Participant(
        photo: participantImage[i]?.path,
        name: nameControllers[i].text,
        age: int.tryParse(ageControllers[i].text) ?? 0,
        groupId: groupId,
      );
      await controllerDatabase.insert(participant);
    }

    nameControllers.clear();
    ageControllers.clear();
    notifyListeners();
  }

  void updateParticipantImage(int index, File image) {
    if (index >= 0 && index < participantImage.length) {
      participantImage[index] = image;
      notifyListeners();
    }
  }

  void removeParticipant(int index) {
    if(index >= 1) {
      nameControllers[index].dispose();
      ageControllers[index].dispose();
      nameControllers.removeAt(index);
      ageControllers.removeAt(index);
      participantImage.removeAt(index);
      notifyListeners();
    }
    else {
      // ShowErrorCode
    }
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _participantList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

}