import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/data/tables/participant_Table.dart';
import '../../domain/entities/participant.dart';

class ParticipantState extends ChangeNotifier {
  final controllerDatabase = ParticipantController();
  final _participantList = <Participant>[];

  List<Participant> get participantList => _participantList;

  void addParticipant() {
    _participantList.add(Participant(name: 'name', age: 0, tripId: 0));
    notifyListeners();
  }

  Future<void> insert(int tripId) async {
    for (final item in _participantList) {
      final insertItem = item.copyWith(
        name: item.nameController?.text,
        age: int.tryParse(item.ageController?.text ?? '0'),
      );

      await controllerDatabase.insert(insertItem);
    }
  }

  void removeParticipant(int index) {
    participantList.removeAt(index);
    notifyListeners();
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _participantList.addAll(list);
    notifyListeners();
  }

  Future<File?> pickImageFromGallery(int participantId) async {
    final dir = await getApplicationDocumentsDirectory();

    final participantDir = Directory('${dir.path}/participants');

    if (!participantDir.existsSync()) {
      await participantDir.create();
    }

    final file = File('${participantDir.path}/$participantId.png');
    if (!file.existsSync()) {
      await file.create();
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    final bytes = await pickedFile?.readAsBytes();
    await file.writeAsBytes(bytes ?? [], mode: FileMode.write);

    print("ççç1");
    print(bytes?.length);

    return file;
  }

  Future<File?> pickImageFromCamera(int participantId) async {
    final dir = await getApplicationDocumentsDirectory();

    final participantDir = Directory('${dir.path}/participants');

    if (!participantDir.existsSync()) {
      await participantDir.create();
    }

    final file = File('${participantDir.path}/$participantId.png');
    if (!file.existsSync()) {
      await file.create();
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    final bytes = await pickedFile?.readAsBytes();
    await file.writeAsBytes(bytes ?? [], mode: FileMode.write);

    print("ççç2");
    print(bytes?.length);

    return file;
  }

  void reload() {
    notifyListeners();
  }
}
