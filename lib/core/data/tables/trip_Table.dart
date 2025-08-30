import 'package:projeto_final_academy/core/data/tables/stop_Table.dart';
import 'package:projeto_final_academy/core/data/tables/participant_Table.dart';
import 'package:projeto_final_academy/core/data/tables/transport_Table.dart';
import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/domain/entities/completeTrip.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';

import '../../../domain/entities/experience.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/participant.dart';
import '../database/app_database.dart';
import 'experience_Table.dart';

class TripTable {
  static const String createTable =
      '''
  CREATE TABLE IF NOT EXISTS $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $tripName TEXT NOT NULL,
  $status INTEGER NOT NULL,
  $departure DATETIME NOT NULL,
  $arrival DATETIME NOT NULL
  );
  ''';

  static const String tableName = 'trips';

  static const String id = 'id';
  static const String tripName = 'tripName';
  static const String status = 'status';
  static const String departure = 'departure';
  static const String arrival = 'arrival';
  static const String participants = 'participants';
  static const String stops = 'stops';
  static const String experiences = 'experiences';

  static Map<String, dynamic> toMap(Trip trip) {
    final map = <String, dynamic>{};

    map[TripTable.id] = trip.id;
    map[TripTable.tripName] = trip.groupName;
    map[TripTable.status] = trip.status;
    map[TripTable.departure] = trip.departure!.toIso8601String();
    map[TripTable.arrival] = trip.arrival!.toIso8601String();

    return map;
  }
}

class TripController {

  Future<CompleteTrip?> getCompleteTrip(int tripId) async {
    final database = await getDatabase();

    final groupResult = await database.query(
      TripTable.tableName,
      where: 'id = ?',
      whereArgs: [tripId],
    );

    if (groupResult.isEmpty) return null;

    final groupRow = groupResult.first;

    final participantsResult = await database.query(
      ParticipantTable.tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );

    final transportsResult = await database.query(
      TransportTable.tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );

    final stopsResult = await database.query(
      StopTable.tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );

    final experiencesResult = await database.query(
      ExperienceTable.tableName,
      where: 'tripId = ?',
      whereArgs: [tripId],
    );

    final participants = participantsResult.map((item) {
      return Participant(
        id: item['id'] as int?,
        photo: item['photo'] as String?,
        name: item['name'] as String,
        age: item['age'] as int,
        tripId: item['tripId'] as int,
      );
    }).toList();

    final transports = transportsResult.map((item) {
      return Transport(
        id: item['id'] as int?,
        transportName: item['transportName'] as String,
        tripId: item['tripId'] as int,
      );
    }).toList();

    final experiences = experiencesResult.map((item) {
      return Experience(
        id: item['id'] as int?,
        type: item['type'] as String,
        tripId: item['tripId'] as int,
      );
    }).toList();

    final stops = stopsResult.map((item) {
      return Stop(
        id: item['id'] as int?,
        name: item['name'] as String,
        address: item['address'] as String,
        latitude: item['latitude'] as double,
        longitude: item['longitude'] as double,
        departure: DateTime.parse(item['departure'] as String),
        arrival: DateTime.parse(item['arrival'] as String),
        photo: item['photo'] as String?,
        tripId: item['tripId'] as int,
      );
    }).toList();

    return CompleteTrip(
      id: groupRow['id'] as int?,
      tripName: groupRow['tripName'] as String,
      status: groupRow['status'] as int,
      departure: DateTime.parse(groupRow['departure'] as String),
      arrival: DateTime.parse(groupRow['arrival'] as String),
      participants: participants,
      transports: transports,
      stops: stops,
      experiences: experiences,
    );
  }

  Future<int> insert(Trip trip) async {
    final database = await getDatabase();
    final map = TripTable.toMap(trip);

    return await database.insert(TripTable.tableName, map);
  }

  Future<List<Trip>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      TripTable.tableName,
    );

    var list = <Trip>[];

    for (final item in result) {
      list.add(
        Trip(
          id: item[TripTable.id],
          groupName: item[TripTable.tripName],
          status: item[TripTable.status],
          departure: DateTime.parse(item[TripTable.departure]),
          arrival: DateTime.parse(item[TripTable.arrival]),
          participants: item[TripTable.participants],
          stops: item[TripTable.stops],
          experiences: item[TripTable.experiences],
        ),
      );
    }
    return list;
  }

  Future<void> update(Trip trip) async {
    final database = await getDatabase();

    var map = TripTable.toMap(trip);

    await database.update(
      TripTable.tableName,
      map,
      where: '${TripTable.id} = ?',
      whereArgs: [trip.id],
    );
  }

  Future<void> delete(Trip trip) async {
    final database = await getDatabase();

    database.delete(
      TripTable.tableName,
      where: '${TripTable.id} = ?',
      whereArgs: [trip.id],
    );
  }
}
