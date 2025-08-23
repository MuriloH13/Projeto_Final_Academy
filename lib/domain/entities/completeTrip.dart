import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/domain/entities/experience.dart';
import 'package:projeto_final_academy/domain/entities/participant.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';

class CompleteTrip {
  final int? id;
  final String tripName;
  final int status;
  final DateTime? departure;
  final DateTime? arrival;
  final List<Participant> participants;
  final List<Transport> transports;
  final List<Stop> cities;
  final List<Experience> experiences;

  CompleteTrip({
    this.id,
    required this.tripName,
    required this.status,
    this.departure,
    this.arrival,
    required this.participants,
    required this.transports,
    required this.cities,
    required this.experiences,
});
}