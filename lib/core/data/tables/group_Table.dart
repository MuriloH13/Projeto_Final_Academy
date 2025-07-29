import '../../../domain/entities/group.dart';
import '../database/app_database.dart';

class GroupTable {
  static const String createTable =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $groupName TEXT NOT NULL
  );
  ''';

  static const String tableName = 'groups';

  static const String id = 'id';

  static const String groupName = 'groupName';

  static Map<String, dynamic> toMap(Group group) {
    final map = <String, dynamic>{};

    map[GroupTable.id] = group.id;
    map[GroupTable.groupName] = group.groupName;

    return map;
  }
}

class GroupController {
  Future<int> insert(Group group) async {
    final database = await getDatabase();
    final map = GroupTable.toMap(group);

    return await database.insert(GroupTable.tableName, map);

  }

  Future<void> delete(Group group) async {
    final database = await getDatabase();

    database.delete(
      GroupTable.tableName,
      where: '${GroupTable.id} = ?',
      whereArgs: [group.id],
    );
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
        ),
      );
    }
    return list;
  }
}
