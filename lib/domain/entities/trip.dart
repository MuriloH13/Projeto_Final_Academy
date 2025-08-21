class Trip {
  final int? id;
  final String groupName;
  final int? participants;
  final int? cities;
  final int? experiences;

  Trip({
    this.id,
    required this.groupName,
    this.participants,
    this.cities,
    this.experiences,
  });
}