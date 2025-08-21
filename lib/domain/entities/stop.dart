class Stop {
  final int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime? departure;
  final DateTime? arrival;
  final String? photo;
  final int tripId;

  Stop({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.departure,
    this.arrival,
    this.photo,
    required this.tripId,
});
}