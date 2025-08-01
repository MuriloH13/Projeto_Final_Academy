class Stops {
  final int? id;
  final String cityName;
  final String address;
  double latitude;
  double longitude;

  Stops({
    this.id,
    required this.cityName,
    required this.address,
    required this.latitude,
    required this.longitude,
});
}