import 'package:projeto_final_academy/domain/entities/transport.dart';

import '../database/app_database.dart';

class TransportTable {
  static const String tableName = 'transports';  // declare antes

  static const String id = 'id';
  static const String transportName = 'transportName';
  static const String tripId = 'tripId';

  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $transportName TEXT NOT NULL,
      $tripId INTEGER NOT NULL,
      FOREIGN KEY (tripId) REFERENCES trips(id) ON DELETE CASCADE
    );
  ''';

  static Map<String, dynamic> toMap(Transport transport) {
    final map = <String, dynamic>{};

    if (transport.id != null) {
      map[id] = transport.id;
    }
    map[transportName] = transport.transportName;
    map[tripId] = transport.tripId;

    return map;
  }
}

class TransportController {

  Future<void> insert(Transport transport) async {
    final database = await getDatabase();
    final map = TransportTable.toMap(transport);

    await database.insert(TransportTable.tableName, map);
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
          tripId: item[TransportTable.tripId],
        ),
      );
    }
    return list;
  }

  Future<List<Transport>> selectWhere(int tripId) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      TransportTable.tableName,
      where: '${TransportTable.tripId} = ?',
      whereArgs: [tripId],
    );

    var list = <Transport>[];

    for (final item in result) {
      list.add(
        Transport(
          id: item[TransportTable.id],
          transportName: item[TransportTable.transportName],
          tripId: item[TransportTable.tripId],
        ),
      );
    }
    return list;
  }

  Future<void> update(Transport transport) async {
    final database = await getDatabase();

    var map = TransportTable.toMap(transport);

    await database.update(
        TransportTable.tableName,
        map,
        where: '${TransportTable.id} = ?',
        whereArgs: [transport.id]
    );

  }

  Future<void> delete(Transport transport) async {
    final database = await getDatabase();

    await database.delete(
      TransportTable.tableName,
      where: '${TransportTable.id} = ?',
      whereArgs: [transport.id],
    );
  }

}