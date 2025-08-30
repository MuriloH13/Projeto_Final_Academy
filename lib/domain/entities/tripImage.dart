class TripImage {
  final int? id;
  final String photo;
  final int tripId;
  final int participantId;

  TripImage({
    this.id,
    required this.photo,
    required this.tripId,
    required this.participantId,
  });
}