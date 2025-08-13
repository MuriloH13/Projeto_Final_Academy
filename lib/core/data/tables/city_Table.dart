import 'package:projeto_final_academy/domain/entities/city.dart';
import '../database/app_database.dart';

class CityTable {
  static const String createTable =
  '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $address TEXT NOT NULL,
  $latitude DOUBLE NOT NULL,
  $longitude DOUBLE NOT NULL,
  $photo TEXT,
  $groupId INTEGER NOT NULL,
  FOREIGN KEY (groupId) REFERENCES GroupTable(id) ON DELETE CASCADE
  );
  ''';

  static const String tableName = 'cities';
  static const String id = 'id';
  static const String name = 'name';
  static const String address = 'address';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String photo = 'photo';
  static const String groupId = 'groupId';

  static Map<String, dynamic> toMap(City city) {
    final map = <String, dynamic>{};
    map[CityTable.id] = city.id;
    map[CityTable.name] = city.name;
    map[CityTable.address] = city.address;
    map[CityTable.latitude] = city.latitude;
    map[CityTable.longitude] = city.longitude;
    map[CityTable.photo] = city.photo;
    map[CityTable.groupId] = city.groupId;

    if (city.id != null) {
      map[CityTable.id] = city.id;
    }

    return map;
  }
}

class CityController {
  Future<void> insert(City city) async {
    final database = await getDatabase();
    final map = CityTable.toMap(city);

    await database.insert(CityTable.tableName, map);

    return;
  }

  Future<List<City>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      CityTable.tableName,
    );

    var list = <City>[];

    for(final item in result) {
      list.add(
          City(
              name: item[CityTable.name],
              address: item[CityTable.address],
              latitude: item[CityTable.latitude],
              longitude: item[CityTable.longitude],
              photo: item[CityTable.photo],
              groupId: item[CityTable.groupId])
      );

    }
    return list;
  }

  Future<void> update(City city) async {
    final database = await getDatabase();

    var map = CityTable.toMap(city);

    await database.update(
        CityTable.tableName,
        map,
        where: '${CityTable.id} = ?',
        whereArgs: [city.id]
    );

  }

  Future<void> delete(City city) async {
    final database = await getDatabase();

    database.delete(
      CityTable.tableName,
      where: '${CityTable.id} = ?',
      whereArgs: [city.id],
    );
  }

}