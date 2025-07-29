import 'package:projeto_final_academy/domain/entities/transport.dart';

import '../database/app_database.dart';
import 'group_Table.dart';  // importe a GroupTable para usar as constantes

class TransportTable {
  static const String tableName = 'transports';  // declare antes

  static const String id = 'id';
  static const String transportName = 'transportName';
  static const String groupId = 'groupId';

  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $transportName TEXT NOT NULL,
      $groupId INTEGER NOT NULL,
      FOREIGN KEY (groupId) REFERENCES GroupTable(id) ON DELETE CASCADE
    );
  ''';

  static Map<String, dynamic> toMap(Transport transport) {
    final map = <String, dynamic>{};

    if (transport.id != null) {
      map[id] = transport.id;
    }
    map[transportName] = transport.transportName;
    map[groupId] = transport.groupId;

    return map;
  }
}

class TransportController {
  Future<void> insert(Transport transport) async {
    final database = await getDatabase();
    final map = TransportTable.toMap(transport);

    await database.insert(TransportTable.tableName, map);
  }

  Future<void> delete(Transport transport) async {
    final database = await getDatabase();

    await database.delete(
      TransportTable.tableName,
      where: '${TransportTable.id} = ?',
      whereArgs: [transport.id],
    );
  }

  Future<List<Transport>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      TransportTable.tableName,
    );

    var list = <Transport>[];

    for (final item in result) {
      list.add(
        Transport(
          id: item[TransportTable.id],
          transportName: item[TransportTable.transportName],
          groupId: item[TransportTable.groupId],
        ),
      );
    }
    return list;
  }
}