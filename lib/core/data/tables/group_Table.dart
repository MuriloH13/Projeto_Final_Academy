import 'package:projeto_final_academy/core/data/tables/city_Table.dart';
import 'package:projeto_final_academy/core/data/tables/participant_Table.dart';
import 'package:projeto_final_academy/core/data/tables/transport_Table.dart';
import 'package:projeto_final_academy/domain/entities/city.dart';
import 'package:projeto_final_academy/domain/entities/completeGroup.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';

import '../../../domain/entities/experience.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/participant.dart';
import '../database/app_database.dart';
import 'experience_Table.dart';

class GroupTable {
  static const String createTable =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $groupName TEXT NOT NULL,
  $participants INTEGER,
  $cities INTEGER,
  $experiences INTEGER
  );
  ''';

  static const String tableName = 'groups';

  static const String id = 'id';

  static const String groupName = 'groupName';
  static const String participants = 'participants';
  static const String cities = 'cities';
  static const String experiences = 'experiences';

  static Map<String, dynamic> toMap(Group group) {
    final map = <String, dynamic>{};

    map[GroupTable.id] = group.id;
    map[GroupTable.groupName] = group.groupName;

    return map;
  }
}

class GroupController {

  Future<CompleteGroup?> getCompleteGroup(int groupId) async {
    final database = await getDatabase();

    final groupResult = await database.query(
      GroupTable.tableName,
      where: 'id = ?',
      whereArgs: [groupId],
    );

    if(groupResult.isEmpty) return null;

    final groupRow = groupResult.first;

    final participantsResult = await database.query(
      ParticipantTable.tableName,
      where: 'groupId = ?',
      whereArgs: [groupId]
    );

    final transportsResult = await database.query(
      TransportTable.tableName,
      where: 'groupId = ?',
      whereArgs: [groupId]
    );

    final citiesResult = await database.query(
      CityTable.tableName,
      where: 'groupId = ?',
      whereArgs: [groupId]
    );

    final experiencesResult = await database.query(
        ExperienceTable.tableName,
        where: 'groupId = ?',
        whereArgs: [groupId]
    );

    final participants = participantsResult.map((item) {
      return Participant(
        id: item['id'] as int?,
        photo: item['photo'] as String?,
        name: item['name'] as String,
        age: item['age'] as int,
        groupId: item['groupId'] as int,
      );
    }).toList();

    final transports = transportsResult.map((item) {
      return Transport(
      id: item['id'] as int?,
        transportName: item['transportName'] as String,
        groupId: item['groupId'] as int,
      );
    }).toList();

    final experiences = experiencesResult.map((item) {
      return Experience(
        id: item['id'] as int?,
        type: item['type'] as String,
        groupId: item['groupId'] as int,
      );
    }).toList();

    final cities = citiesResult.map((item) {
      return City(
          id: item['id'] as int?,
          name: item['name'] as String,
          address: item['address'] as String,
          latitude: item['latitude'] as double,
          longitude: item['longitude'] as double,
          photo: item['photo'] as String?,
          groupId: item['groupId'] as int,
      );
    }).toList();

    return CompleteGroup(
      id: groupRow['id'] as int?,
        groupName: groupRow['groupName'] as String,
        participants: participants,
        transports: transports,
        cities: cities,
        experiences: experiences,
    );
  }

  Future<int> insert(Group group) async {
    final database = await getDatabase();
    final map = GroupTable.toMap(group);

    return await database.insert(GroupTable.tableName, map);

  }

  Future<List<Group>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      GroupTable.tableName,
    );

    var list = <Group>[];

    for (final item in result) {
      list.add(
        Group(
          id: item[GroupTable.id],
          groupName: item[GroupTable.groupName],
          participants: item[GroupTable.participants],
          cities: item[GroupTable.cities],
          experiences: item[GroupTable.experiences],
        ),
      );
    }
    return list;
  }

  Future<void> update(Group group) async {
    final database = await getDatabase();
    
    var map = GroupTable.toMap(group);
    
    await database.update(
      GroupTable.tableName,
      map,
      where: '${GroupTable.id} = ?',
      whereArgs: [group.id]
    );
    
  }

  Future<void> delete(Group group) async {
    final database = await getDatabase();

    database.delete(
      GroupTable.tableName,
      where: '${GroupTable.id} = ?',
      whereArgs: [group.id],
    );
  }
}
