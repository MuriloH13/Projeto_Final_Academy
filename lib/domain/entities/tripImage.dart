class TripImage {
  final int? id;
  final String photo;
  final String? report;
  final int stopId;
  final int participantId;

  TripImage({
    this.id,
    required this.photo,
    this.report,
    required this.stopId,
    required this.participantId,
  });
}