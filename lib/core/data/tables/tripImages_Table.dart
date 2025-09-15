import 'package:projeto_final_academy/core/data/database/app_database.dart';
import 'package:projeto_final_academy/domain/entities/tripImage.dart';

class TripImagesTable {
  static const String createTable =
      '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $photo TEXT NOT NULL,
  $report TEXT,
  $stopId INTEGER NOT NULL,
  $participantId INTEGER NOT NULL,
  FOREIGN KEY (stopId) REFERENCES stops(id) ON DELETE CASCADE
  FOREIGN KEY (participantId) REFERENCES participants(id) ON DELETE CASCADE
  );
  ''';

  static const String tableName = 'tripImages';
  static const String id = 'id';
  static const String photo = 'photo';
  static const String report = 'report';
  static const String stopId = 'stopId';
  static const String participantId = 'participantId';

  static Map<String, dynamic> toMap(TripImage image) {
    final map = <String, dynamic>{};
    map[TripImagesTable.id] = image.id;
    map[TripImagesTable.photo] = image.photo;
    map[TripImagesTable.report] = image.report;
    map[TripImagesTable.stopId] = image.stopId;
    map[TripImagesTable.participantId] = image.participantId;

    if (image.id != null) {
      map[TripImagesTable.id] = image.id;
    }

    return map;
  }
}

class TripImageController {
  Future<void> insert(TripImage image) async {
    final database = await getDatabase();
    final map = TripImagesTable.toMap(image);

    await database.insert(TripImagesTable.tableName, map);

    return;
  }

  Future<List<TripImage>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      TripImagesTable.tableName,
    );

    var list = <TripImage>[];

    for (final item in result) {
      list.add(
        TripImage(
          photo: item[TripImagesTable.photo],
          stopId: item[TripImagesTable.stopId],
          participantId: item[TripImagesTable.participantId],
        ),
      );
    }
    return list;
  }

  Future<List<TripImage>> selectWhere(int stopId, {int? participantId}) async {
    final database = await getDatabase();

    String whereClause = '${TripImagesTable.stopId} = ?';
    List<dynamic> whereArgs = [stopId];

    if (participantId != null) {
      whereClause += ' AND ${TripImagesTable.participantId} = ?';
      whereArgs.add(participantId);
    }

    final List<Map<String, dynamic>> result = await database.query(
      TripImagesTable.tableName,
      where: whereClause,
      whereArgs: whereArgs,
    );

    var list = <TripImage>[];

    for (final item in result) {
      list.add(
        TripImage(
          photo: item[TripImagesTable.photo],
          stopId: item[TripImagesTable.stopId],
          participantId: item[TripImagesTable.participantId],
        ),
      );
    }

    return list;
  }

  Future<void> update(TripImage image) async {
    final database = await getDatabase();

    var map = TripImagesTable.toMap(image);

    await database.update(
      TripImagesTable.tableName,
      map,
      where: '${TripImagesTable.id} = ?',
      whereArgs: [image.id],
    );
  }

  Future<void> delete(TripImage image) async {
    final database = await getDatabase();

    await database.delete(
      TripImagesTable.tableName,
      where: '${TripImagesTable.id} = ?',
      whereArgs: [image.id],
    );
  }
}
