import 'package:projeto_final_academy/domain/entities/stop.dart';
import 'package:projeto_final_academy/domain/entities/experience.dart';
import 'package:projeto_final_academy/domain/entities/participant.dart';
import 'package:projeto_final_academy/domain/entities/transport.dart';
import 'package:projeto_final_academy/domain/entities/tripImage.dart';

class CompleteTrip {
  final int? id;
  final String tripName;
  final int status;
  final List<TripImage> tripImages;
  final DateTime? departure;
  final DateTime? arrival;
  final List<Participant> participants;
  final List<Transport> transports;
  final List<Stop> stops;
  final List<Experience> experiences;

  CompleteTrip({
    this.id,
    required this.tripName,
    required this.status,
    required this.tripImages,
    this.departure,
    this.arrival,
    required this.participants,
    required this.transports,
    required this.stops,
    required this.experiences,
});
}