class Trip {
  final int? id;
  final String tripName;
  final int status;
  final int? photos;
  final DateTime? departure;
  final DateTime? arrival;
  final int? participants;
  final int? stops;
  final int? experiences;

  Trip({
    this.id,
    required this.tripName,
    required this.status,
    this.photos,
    this.departure,
    this.arrival,
    this.participants,
    this.stops,
    this.experiences,
  });
}