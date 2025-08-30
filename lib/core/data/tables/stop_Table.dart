import 'package:projeto_final_academy/domain/entities/stop.dart';
import '../database/app_database.dart';

class StopTable {
  static const String createTable =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $address TEXT NOT NULL,
  $latitude DOUBLE NOT NULL,
  $longitude DOUBLE NOT NULL,
  $departure DATETIME NOT NULL,
  $arrival DATETIME NOT NULL,
  $photo TEXT,
  $tripId INTEGER NOT NULL,
  FOREIGN KEY (tripId) REFERENCES TripTable(id) ON DELETE CASCADE
  );
  ''';

  static const String tableName = 'cities';
  static const String id = 'id';
  static const String name = 'name';
  static const String address = 'address';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String departure = 'departure';
  static const String arrival = 'arrival';
  static const String photo = 'photo';
  static const String tripId = 'tripId';

  static Map<String, dynamic> toMap(Stop stop) {
    final map = <String, dynamic>{};
    map[StopTable.id] = stop.id;
    map[StopTable.name] = stop.name;
    map[StopTable.address] = stop.address;
    map[StopTable.latitude] = stop.latitude;
    map[StopTable.longitude] = stop.longitude;
    map[StopTable.departure] = stop.departure!.toIso8601String();
    map[StopTable.arrival] = stop.arrival!.toIso8601String();
    map[StopTable.photo] = stop.photo;
    map[StopTable.tripId] = stop.tripId;

    if (stop.id != null) {
      map[StopTable.id] = stop.id;
    }

    return map;
  }
}

class StopController {
  Future<void> insert(Stop stop) async {
    final database = await getDatabase();
    final map = StopTable.toMap(stop);

    await database.insert(StopTable.tableName, map);

    return;
  }

  Future<List<Stop>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      StopTable.tableName,
    );

    var list = <Stop>[];

    for(final item in result) {
      list.add(
          Stop(
              name: item[StopTable.name],
              address: item[StopTable.address],
              latitude: item[StopTable.latitude],
              longitude: item[StopTable.longitude],
              departure: DateTime.parse(item[StopTable.departure]),
              arrival: DateTime.parse(item[StopTable.arrival]),
              photo: item[StopTable.photo],
              tripId: item[StopTable.tripId])
      );

    }
    return list;
  }

  Future<void> update(Stop stop) async {
    final database = await getDatabase();

    var map = StopTable.toMap(stop);

    await database.update(
        StopTable.tableName,
        map,
        where: '${StopTable.id} = ?',
        whereArgs: [stop.id]
    );
  }

  Future<void> delete(Stop stop) async {
    final database = await getDatabase();

    database.delete(
      StopTable.tableName,
      where: '${StopTable.id} = ?',
      whereArgs: [stop.id],
    );
  }
}