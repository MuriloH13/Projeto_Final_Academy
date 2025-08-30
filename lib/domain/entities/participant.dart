import 'dart:io';

import 'package:flutter/cupertino.dart';

class Participant {
  final int? id;
  final String? photo;
  final File? photoFile;
  final String? name;
  final int? age;
  final int? tripId;

  final TextEditingController? nameController;
  final TextEditingController? ageController;

  Participant({
    this.id,
    this.photo,
    this.photoFile,
    this.name,
    this.age,
    this.tripId,
    this.nameController,
    this.ageController,
  });

  Participant copyWith({
    int? id,
    String? photo,
    File? photoFile,
    String? name,
    int? age,
    int? tripId,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      photoFile: photoFile ?? this.photoFile,
      age: age ?? this.age,
      tripId: tripId ?? this.tripId,
    );
  }
}
