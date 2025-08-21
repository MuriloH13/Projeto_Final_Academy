import 'package:projeto_final_academy/domain/entities/experience.dart';

import '../database/app_database.dart';

class ExperienceTable {
  static const String tableName = 'experiences';  // declare antes

  static const String id = 'id';
  static const String type = 'type';
  static const String tripId = 'tripId';

  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $type TEXT NOT NULL,
      $tripId INTEGER NOT NULL,
      FOREIGN KEY (tripId) REFERENCES TripTable(id) ON DELETE CASCADE
    );
  ''';

  static Map<String, dynamic> toMap(Experience experience) {
    final map = <String, dynamic>{};

    if (experience.id != null) {
      map[id] = experience.id;
    }
    map[type] = experience.type;
    map[tripId] = experience.tripId;

    return map;
  }
}

class ExperienceController {

  Future<void> insert(Experience experience) async {
    final database = await getDatabase();
    final map = ExperienceTable.toMap(experience);

    await database.insert(ExperienceTable.tableName, map);
  }

  Future<List<Experience>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ExperienceTable.tableName,
    );

    var list = <Experience>[];

    for (final item in result) {
      list.add(
        Experience(
          id: item[ExperienceTable.id],
          type: item[ExperienceTable.type],
          tripId: item[ExperienceTable.tripId],
        ),
      );
    }
    return list;
  }

  Future<void> update(Experience experience) async {
    final database = await getDatabase();

    var map = ExperienceTable.toMap(experience);

    await database.update(
        ExperienceTable.tableName,
        map,
        where: '${ExperienceTable.id} = ?',
        whereArgs: [experience.id]
    );

  }

  Future<void> delete(Experience experience) async {
    final database = await getDatabase();

    await database.delete(
      ExperienceTable.tableName,
      where: '${ExperienceTable.id} = ?',
      whereArgs: [experience.id],
    );
  }

}