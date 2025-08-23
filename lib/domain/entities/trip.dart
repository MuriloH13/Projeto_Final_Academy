class Trip {
  final int? id;
  final String groupName;
  final int status;
  final DateTime? departure;
  final DateTime? arrival;
  final int? participants;
  final int? stops;
  final int? experiences;

  Trip({
    this.id,
    required this.groupName,
    required this.status,
    this.departure,
    this.arrival,
    this.participants,
    this.stops,
    this.experiences,
  });
}