class Participant {
  final int? id;
  final String? photo;
  final String name;
  final int age;
  final int groupId;

  Participant({
    this.id,
    this.photo,
    required this.name,
    required this.age,
    required this.groupId,
  });
}
