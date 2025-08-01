import '../../../domain/entities/participant.dart';
import '../database/app_database.dart';

class ParticipantTable {
  static const String createTable =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $photo TEXT,
  $name TEXT NOT NULL,
  $age INTEGER NOT NULL,
  $groupId INTEGER NOT NULL,
  FOREIGN KEY (groupId) REFERENCES GroupTable(id) ON DELETE CASCADE
  );
  ''';

  static const String tableName = 'participants';
  static const String id = 'id';
  static const String photo = 'photo';
  static const String name = 'name';
  static const String age = 'age';
  static const String groupId = 'groupId';

  static Map<String, dynamic> toMap(Participant participant) {
    final map = <String, dynamic>{};
    map[ParticipantTable.photo] = participant.photo;
    map[ParticipantTable.name] = participant.name;
    map[ParticipantTable.age] = participant.age;
    map[ParticipantTable.groupId] = participant.groupId;

    if (participant.id != null) {
      map[ParticipantTable.id] = participant.id;
    }

    return map;
  }
}

class ParticipantController {
  Future<void> insert(Participant participant) async {
    final database = await getDatabase();
    final map = ParticipantTable.toMap(participant);

    await database.insert(ParticipantTable.tableName, map);

    return;
  }

  Future<void> delete(Participant participant) async {
    final database = await getDatabase();

    database.delete(
      ParticipantTable.tableName,
      where: '${ParticipantTable.id} = ?',
      whereArgs: [participant.id],
    );
  }

  Future<List<Participant>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ParticipantTable.tableName,
    );

    var list = <Participant>[];

    for(final item in result) {
      list.add(
          Participant(
            photo: item[ParticipantTable.photo],
              name: item[ParticipantTable.name],
              age: item[ParticipantTable.age],
              groupId: item[ParticipantTable.groupId])
      );

    }
    return list;
  }
}