class Participant {
  final int? id;
  final String? photo;
  final String name;
  final int age;
  final int tripId;

  Participant({
    this.id,
    this.photo,
    required this.name,
    required this.age,
    required this.tripId,
  });
}
