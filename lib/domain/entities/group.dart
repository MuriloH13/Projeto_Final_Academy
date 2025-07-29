class Group {
  final int? id;
  final String groupName;
  final int? participants;
  final int? cities;
  final int? experiences;

  Group({
    this.id,
    required this.groupName,
    this.participants,
    this.cities,
    this.experiences,
  });
}