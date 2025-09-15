import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/data/tables/participant_Table.dart';
import '../../domain/entities/participant.dart';

class ParticipantState extends ChangeNotifier {
  ParticipantState() {
    addParticipant();
  }

  final controllerDatabase = ParticipantController();
  final _participantList = <Participant>[];

  List<Participant> get participantList => _participantList;

  void addParticipant() {
    _participantList.add(
      Participant(
        nameController: TextEditingController(),
        ageController: TextEditingController(),
      ),
    );
    notifyListeners();
  }

  /// Insere participantes no banco e atualiza seus IDs
  Future<void> insert(int tripId) async {
    for (Participant item in _participantList) {
      final name = item.nameController?.text.trim().isNotEmpty ?? false
          ? item.nameController!.text.trim()
          : "No name";

      final age = int.tryParse(item.ageController?.text ?? "") ?? 0;

      // Criar o objeto participante
      final participant = Participant(
        name: name,
        age: age,
        tripId: tripId,
      );

      // Inserir no banco e obter ID
      final id = await controllerDatabase.insert(participant);

      // Se tiver foto, salvar arquivo com ID correto
      if (item.photo != null) {
        final newPath = await _savePhotoWithDbId(item.photo!, id);
        await controllerDatabase.updatePhoto(id, newPath);
      }

      item.nameController?.clear();
      item.ageController?.clear();
    }

    _participantList.clear();
    notifyListeners();
  }

  /// Salva a foto usando o ID do banco para nomear o arquivo
  Future<String> _savePhotoWithDbId(String oldPath, int dbId) async {
    final dir = await getApplicationDocumentsDirectory();
    final participantDir = Directory('${dir.path}/participants');

    if (!await participantDir.exists()) {
      await participantDir.create(recursive: true);
    }

    final file = File(oldPath);
    final newPath = '${participantDir.path}/$dbId.png';
    await file.copy(newPath); // copia a imagem para o local correto
    return newPath;
  }

  Future<File?> pickImage({required Participant participant, required bool fromCamera}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    participant.photo = pickedFile.path;
    notifyListeners();
    return File(pickedFile.path);
  }

  void removeParticipant(int index) {
    if (_participantList.length > 1) {
      _participantList.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> load() async {
    final list = await controllerDatabase.select();
    _participantList
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }
}