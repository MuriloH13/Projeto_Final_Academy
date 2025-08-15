import 'package:path/path.dart';
import 'package:projeto_final_academy/core/data/tables/transport_Table.dart';
import 'package:sqflite/sqflite.dart';
import '../tables/city_Table.dart';
import '../tables/experience_Table.dart';
import '../tables/group_Table.dart';
import '../tables/participant_Table.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'travels.db');


  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(GroupTable.createTable);
      db.execute(ParticipantTable.createTable);
      db.execute(TransportTable.createTable);
      db.execute(CityTable.createTable);
      db.execute(ExperienceTable.createTable);
    },
    version: 1,
  );
}



