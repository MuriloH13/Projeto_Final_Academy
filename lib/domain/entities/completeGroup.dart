import 'package:projeto_final_academy/domain/entities/city.dart';
import 'package:projeto_final_academy/domain/entities/experience.dart';
import 'package:projeto_final_academy/domain/entities/participant.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';

class CompleteGroup {
  final int? id;
  final String groupName;
  final List<Participant> participants;
  final List<Transport> transports;
  final List<City> cities;
  // final List<Experience> experiences;

  CompleteGroup({
    this.id,
    required this.groupName,
    required this.participants,
    required this.transports,
    required this.cities,
    // required this.experiences,
});
}