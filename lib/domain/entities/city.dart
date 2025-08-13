class City {
  final int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? photo;
  final int groupId;

  City({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photo,
    required this.groupId,
});
}